# md5checker

## Synopsis

	md5checker [-q] source_file
	md5checker [-v] [-h]

## Description

Reads MD5 (128-bits) checksums in the file and compare them to the files

	-q
		Quiet mode. Don't print OK messages or warnings messages

	-h
		Displays this help and exits

	-v
		Outputs the version information and exits

## How to generate a standard MD5SUM file

The default OSX `md5` command doesn't provide a way to output standard md5sum file content so here how to:

```bash
# md5 default command output:
~$ md5 LICENSE
MD5 (LICENSE) = cc569e106f17cd9ad8f5e71a7dcf6155
# MD5SUM output:
~$ md5 LICENSE | sed "s/^MD5 (//" | sed "s/) =/ /" | awk '{t=$1;$1=$NF;$NF=" "t}1'
cc569e106f17cd9ad8f5e71a7dcf6155  LICENSE
```

From now:

```bash
~$ find . -not -name "MD5SUMS" -not -empty -type f -d 1 | \
xargs -I %s basename %s | \
xargs -I %s md5 %s | \
sed "s/^MD5 (//" | \
sed "s/) =/ /" | \
awk '{t=$1;$1=$NF;$NF=" "t}1' \
>> MD5SUMS
~$ cat MD5SUMS 
cc569e106f17cd9ad8f5e71a7dcf6155  LICENSE
fd3f07abc89a9ebb6f66446f22c6fbbc  md5checker.sh
2b2169220e3e035ccb43e532362d50e3  README.md
```

## Author

Written by Joris Berthelot <admin@eexit.net>  
https://github.com/eexit/md5checker  
http://www.eexit.net/projects/md5checker.html
