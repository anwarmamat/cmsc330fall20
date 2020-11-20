# Project 5: Introduction to Cybersecurity
Due: 30 November 2020 at 23:59 (Late 1 December)

P/SP/S: 28/72/0

## Introduction
After returning to their respective dimensions in *Spider-Man: Into the Spider-Verse*, the different spider-people wanted a way to continue to communicate between their dimensions. Miles Morales, after taking a couple of computer science classes at Brooklyn Visions Academy, tried his hand at making Spidey-Web, a cross dimensional forum for the different spider-people to communicate with one another. Despite being able to figure out how to send Internet data across dimensions, Miles is not entirely sure if Spidey-Web is completely secure against attacks that might be launched against it by the enemies of the various spider-people. Your job is to help Miles ensure that Spider's Web is secure and can help protect the data of his friends!

## Important Note
The public tests for this project check for correctness of the website. You should be passing all the public tests from the beginning. As you work on the project you might break something that cause the public tests to fail. Your public tests must **all** pass in your final submission to get credit for this project. If any public tests fails, you will recieve a zero for the project.

## Submission

You will submit this project to Gradescope.  Only submit **controller.rb**, any other files will be ignored.  You can use the `gradescope-submit` command if you have it installed.

### Preliminaries
The application is written in Ruby, and is separated into three components:

- The front-end which consists of all the HTML and CSS required for rendering the page. You won't have to worry about this at all.
- The back-end which handles client requests. You will  be working on this component.
- The database which persistently stores information.

When a user requests a page (via HTTP GET), all necessary data from `controller.rb` and `main.rb` will display the appropriate page. When a user submits a form (via HTTP POST), methods in `controller.rb` will be invoked to modify the database.

This project's back-end (written in Ruby in the file `controller.rb`) is vulnerable to exploitation. Your job is to identify and fix as many of the vulnerabilities as possible. Identifying these issues will require recalling some of the vulnerabilities discussed in class, as well as using your own common sense. This will **require** playing with the site, thinking like an attacker, and trying as hard as possible to break things. Of course, you're also expected to fix the issues once you've found them.

The only code you will be modifying is in `controller.rb`. If you're interested in how the application works, you may check out `main.rb`, but this is not necessary.

## Running the project

- Run `bundle install` in the project root directory. If you get a permissions error run with `sudo`.
- Run `ruby src/main.rb`.
- Open [http://localhost:8080/](http://localhost:8080/). You should see the site.
- To run the public tests, run `ruby test/public/public.rb`

Remember to run `ruby src/main.rb` after changing `controller.rb`. Otherwise, changes won't show up.

## Troubleshooting

NOTE: we use `apt-get` below.  You need to use the package manager on your system (e.g. `brew` on mac)

- If you don't have bundler, use `gem install bundler` (on Bash for Windows 10 you need to specify the full path when you call `bundle` which can be found with `gem which bundler`).
- If you don't have SQLite3, use `sudo apt-get install sqlite3`.
- If you're getting an issue where Ruby headers cannot be found run `sudo apt-get install ruby-dev`.
- If you're getting an issue where `sqlite.h` is missing run `sudo apt-get install libsqlite3-dev`.
- If bundler can't continue when installing SQLite3 and you're using macOS, upgrade your version of Ruby (we recommend using RVM).
- If bundler can't continue when installing SQLite3 and you're using Linux, try `sudo apt-get install build-essential patch` followed by `sudo apt-get install ruby-dev zlib1g-dev liblzma-dev`.

## Task: Patch Exploits
In the real world, no one will tell you what vulnerabilities are present in your application. So neither will we. However, here is some advice:

1. **Play with the site.** Spend a good bit of time just interacting with it and understanding the pages and how it works.
2. **Walk through the code.** Since we've written most of the application you need to understand what's already there. Make sure you understand all the methods in `controller.rb` and how they fit within the site. The inline documentation should help with this.
3. **Try breaking things.** Wreak havoc! Be destructive! You will find some rather obvious issues, but also some more subtle ones. Remember the types of exploits discussed in class and discussion. Make note of your findings. Your knowledge of `controller.rb` should be helpful in finding possible exploits.
4. **Start fixing.** Enough said.

Here is an index of the vulnerabilities we've learned about either in class or discussion. This is not meant to be exhaustive, nor does it mean that all of these exploits are relevant to this project. It's just to refresh your memory.

* [Buffer Overflow](http://www.cs.umd.edu/class/fall2017/cmsc330/lectures/software-security.pdf#page=15)
* [Shell Injection](http://www.cs.umd.edu/class/fall2017/cmsc330/lectures/software-security.pdf#page=31)
* [Path Traversal](http://www.cs.umd.edu/class/fall2017/cmsc330/lectures/software-security.pdf#page=47)
* [SQL Injection](http://www.cs.umd.edu/class/fall2017/cmsc330/lectures/software-security-2.pdf#page=14)
* [XSS](http://www.cs.umd.edu/class/fall2017/cmsc330/lectures/software-security-2.pdf#page=56)
* [CSRF](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF))

## Academic Integrity
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[git instructions]: ../git_cheatsheet.md
[submit server]: submit.cs.umd.edu
[web submit link]: ../common-images/web_submit.jpg
[web upload example]: ../common-images/web_upload.jpg
