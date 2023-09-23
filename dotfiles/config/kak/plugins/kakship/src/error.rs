use std::{env, fmt, io};

pub enum Error {
	ConfigVar(env::VarError),
	Io(io::Error),
	Starship(String),
}

impl fmt::Debug for Error {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		match *self {
			Error::ConfigVar(ref err) => {
				match err {
					env::VarError::NotPresent => write!(f, "$kak_config should be exported and point to a directory containing starship.toml"),
					env::VarError::NotUnicode(_) => write!(f, "$kak_config value is not valid")
				}
			},
			Error::Io(ref err) => write!(f, "Error executing starship {:?}", err),
			Error::Starship(ref err) => write!(f, "{:?}", err)
		}
	}
}

impl From<env::VarError> for Error {
	fn from(err: env::VarError) -> Self {
		Error::ConfigVar(err)
	}
}

impl From<io::Error> for Error {
	fn from(err: io::Error) -> Self {
		Error::Io(err)
	}
}
