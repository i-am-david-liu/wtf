# wtf - [w]hat's [t]hat [f]ile?
`wtf` is a tiny CLI for taking notes on files and folders within a directory.
## Usage
- `wtf` displays all the notes for your files and folders within the current directory. A `.wtf` file must be initialized first.
- `wtf init` sets up a file named `.wtf` within the current directory. This file keeps track of your notes.
- `wtf note <file> <note>` adds a note to the specified file.
## Example
```
$ wtf
.test       | hi
.test3/     |
math.c      |
journal/    |
TODO.txt    | my computer-related TODO file
$ wtf note math.c "math project code" 
$ wtf note journal/ "daily writing pad"
$ wtf
.test       | hi
.test3/     |
math.c      | math project code
journal/    | daily writing pad
TODO.txt    | my computer-related TODO file
```
## TODO
[ ] monitor new / deleted files and change `.wtf` accordingly
[ ] `wtf <file>` should return a note corresponding to that file
[ ] A way to only display files with notes attached
[ ] A way to add a note to multiple files
[ ] colored output
