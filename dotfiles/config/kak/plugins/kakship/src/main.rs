mod error;

use crate::error::Error;
use kak::{escape::Mode, face};
use std::{env, path::Path, process::Command};

fn main() -> Result<(), Error> {
	let config = Path::new(&env::var("kak_config")?).join("starship.toml");
	let args: Vec<String> = env::args().skip(1).collect();
	let starship = Command::new("starship")
		.env("STARSHIP_SHELL", "sh")
		.env("STARSHIP_CONFIG", config)
		.args(&args)
		.output()?;

	return if starship.status.code() != Some(0) {
		Err(Error::Starship(
			String::from_utf8_lossy(&starship.stderr).into(),
		))
	} else {
		let stdout = String::from_utf8_lossy(&starship.stdout);
		if args.first().filter(|v| *v == "prompt").is_some() {
			face::print(&stdout, Mode::Block);
		} else {
			println!("{}", stdout);
			eprintln!("{}", String::from_utf8_lossy(&starship.stderr));
		}
		Ok(())
	};
}
