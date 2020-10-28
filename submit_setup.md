# Submitting to Gradescope from the Command-Line

* You must have Rust installed for this to work.  Go to https://www.rust-lang.org/tools/install to install Rust (it should only take a minute or so).
* You might need to install OpenSSL (on Ubuntu, run `sudo apt install libssl-dev`, or on Mac run `brew install openssl`)
* Run `cargo install gradescope-submit`.  This will install a program called `gradescope-submit`.
* In the project directory, run `gradescope-submit`, and enter your Gradescope credentials.  This will submit your project to Gradescope (note this only works from project 4a onwards).
    * If you get an error saying the command doesn't exist, you might have to close your terminal and open a new one.  If it still doesn't work, add `export PATH="$HOME/.cargo/bin:$PATH"` to your **~/.profile** file.
