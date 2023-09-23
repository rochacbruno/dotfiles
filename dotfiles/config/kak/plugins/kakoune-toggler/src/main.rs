use anyhow::{Context, Result};
use serde::Deserialize;
use std::collections::HashMap;
use std::env::args;
use std::fs;
use std::io;
use std::path::PathBuf;

enum Casing {
    IsLower,
    IsUpper,
    IsTitle,
    Original,
}

#[derive(Deserialize)]
struct LanguageToggle<'a> {
    #[serde(borrow)]
    extends: Option<Vec<&'a str>>,
    #[serde(borrow)]
    toggles: Vec<Vec<&'a str>>,
}

fn main() -> Result<()> {
    // Skip the first arg, since this is just the binary
    let mut args = args().skip(1);
    let config_path = args.next().context("Not given a config directory")?;
    // This is not always needed, then we'll just check global toggles
    let filetype = args.next();

    // Get the search_word to be toggled
    let mut buffer = String::new();
    io::stdin()
        .read_line(&mut buffer)
        .context("Need a word to toggle")?;
    let search_word = buffer.trim();

    // Get the casing of the search word
    let word_casing = {
        if search_word.to_lowercase() == search_word {
            Casing::IsLower
        } else if search_word.to_uppercase() == search_word {
            Casing::IsUpper
        } else {
            // Grab the first codepoint
            let first_char = search_word
                .chars()
                .next()
                .context("There isn't a first char?")?;

            // Make the codepoint uppercase
            // It is possible that it can become multiple codepoints,
            //  but we're only checking whether it's the same as the original anyway
            let first_char_upper = first_char.to_uppercase().next().with_context(|| {
                format!("Somehow the char '{}' couldn't be uppered", first_char)
            })?;

            if first_char_upper == first_char {
                Casing::IsTitle
            } else {
                Casing::Original
            }
        }
    };

    // Make the toggle file path
    let path: PathBuf = [&config_path, "toggles.toml"].iter().collect();

    // Read the toggle file
    let bytes = fs::read(&path).with_context(|| {
        format!(
            "Something went wrong with reading the toggle file: {}",
            path.to_string_lossy()
        )
    })?;

    // Parse the toggle file into a table
    let table: HashMap<&str, LanguageToggle> = toml::from_slice(&bytes).with_context(|| {
        format!(
            "Something went wrong parsing the toggle file: {}",
            path.to_string_lossy()
        )
    })?;

    // Queue of each file to check in sequence
    let mut filetype_stack = vec!["global"];

    // Add the (possible) filetype
    if let Some(typ) = filetype.as_deref() {
        filetype_stack.push(typ);
    }

    // Check each type in sequence
    let found_word = loop {
        // Grab the next type
        if let Some(lang_type) = filetype_stack.pop() {
            // Try and grab the filetype
            if let Some(lang_toggles) = table.get(&lang_type) {
                // Find the search word
                if let Some(found_word) = lang_toggles
                    .toggles
                    .iter()
                    .find_map(|arr| get_next_word(arr, &search_word.to_lowercase()))
                {
                    // If found, break out of loop
                    break Some(found_word);
                };
                // If it has any extensions, add it to the stack
                if let Some(extra_filetypes) = &lang_toggles.extends {
                    filetype_stack.extend_from_slice(extra_filetypes);
                }
            }
        } else {
            break None;
        }
    };

    // Print out found toggle or original if not found
    print!(
        "{}",
        found_word
            .and_then(|word| match word_casing {
                Casing::IsLower => Some(word.to_lowercase()),
                Casing::IsUpper => Some(word.to_uppercase()),
                Casing::Original => Some(word.to_owned()),
                Casing::IsTitle => {
                    let first_char = word.chars().next()?;
                    let mut new_word = first_char.to_uppercase().to_string();
                    new_word.push_str(&word.chars().skip(1).collect::<String>());
                    Some(new_word)
                }
            })
            .unwrap_or_else(|| buffer.to_owned())
    );

    Ok(())
}

fn get_next_word<'a>(word_array: &[&'a str], search_word: &str) -> Option<&'a str> {
    // Find the position of search_word
    word_array
        .iter()
        .map(|word| word.to_lowercase())
        .position(|current_word| current_word == search_word)
        .and_then(|found_index| word_array.iter().copied().cycle().nth(found_index + 1))
}
