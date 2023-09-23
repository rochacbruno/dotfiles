use indoc::formatdoc;
use itertools::Itertools;
use lsp_types::{
    request::InlayHintRequest, InlayHint, InlayHintLabel, InlayHintParams, Position, Range,
    TextDocumentIdentifier, Url,
};
use serde::Deserialize;

use crate::{
    capabilities::{attempt_server_capability, CAPABILITY_INLAY_HINTS},
    context::Context,
    markup::escape_kakoune_markup,
    position::lsp_position_to_kakoune,
    types::{EditorMeta, EditorParams},
    util::{editor_quote, escape_tuple_element},
};

#[derive(Debug, PartialEq, Clone, Default, Serialize, Deserialize)]
struct InlayHintsOptions {
    buf_line_count: u32,
}

pub fn inlay_hints(meta: EditorMeta, params: EditorParams, ctx: &mut Context) {
    if meta.fifo.is_none() && !attempt_server_capability(ctx, &meta, CAPABILITY_INLAY_HINTS) {
        return;
    }

    let params = InlayHintsOptions::deserialize(params).unwrap();
    let req_params = InlayHintParams {
        work_done_progress_params: Default::default(),
        text_document: TextDocumentIdentifier {
            uri: Url::from_file_path(&meta.buffile).unwrap(),
        },
        range: Range::new(Position::new(0, 0), Position::new(params.buf_line_count, 0)),
    };
    ctx.call::<InlayHintRequest, _>(meta, req_params, move |ctx, meta, response| {
        inlay_hints_response(meta, response.unwrap_or_default(), ctx)
    });
}

pub fn inlay_hints_response(meta: EditorMeta, inlay_hints: Vec<InlayHint>, ctx: &mut Context) {
    let document = match ctx.documents.get(&meta.buffile) {
        Some(document) => document,
        None => return,
    };
    let ranges = inlay_hints
        .into_iter()
        .map(
            |InlayHint {
                 position,
                 label,
                 padding_left,
                 padding_right,
                 ..
             }| {
                let position =
                    lsp_position_to_kakoune(&position, &document.text, ctx.offset_encoding);
                let label = match label {
                    InlayHintLabel::String(s) => s,
                    InlayHintLabel::LabelParts(parts) => {
                        parts.iter().map(|x| x.value.as_str()).collect()
                    }
                };
                let padding_left = if padding_left.unwrap_or(false) {
                    " "
                } else {
                    ""
                };
                let padding_right = if padding_right.unwrap_or(false) {
                    "{Default} "
                } else {
                    ""
                };
                let label = escape_tuple_element(&escape_kakoune_markup(&label));
                editor_quote(&format!(
                    "{position}+0|{padding_left}{{InlayHint}}{label}{padding_right}",
                ))
            },
        )
        .join(" ");
    let version = meta.version;
    let command = formatdoc!(
        "set-option buffer lsp_inlay_hints {version} {ranges}
         set-option buffer lsp_inlay_hints_timestamp {version}"
    );
    let command = format!(
        "evaluate-commands -buffer {} -- {}",
        editor_quote(&meta.buffile),
        editor_quote(&command)
    );
    ctx.exec(meta, command)
}
