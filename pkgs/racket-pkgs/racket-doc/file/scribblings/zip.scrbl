#lang scribble/doc
@(require "common.rkt" (for-label file/zip file/gzip file/gunzip scheme/file))

@title[#:tag "zip"]{@exec{zip} File Creation}

@defmodule[file/zip]{The @racketmodname[file/zip] library provides
utilities to create @exec{zip} archive files, which are compatible
with both Windows and Unix (including Mac OS X) unpacking. The actual
compression is implemented by @racket[deflate].}

@defproc[(zip [zip-file path-string?] [path path-string?] ...
              [#:timestamp timestamp (or/c #f exact-integer?) #f]
              [#:get-timestamp get-timestamp
                               (path? . -> . exact-integer?)
                               (if timestamp
                                   (lambda (p) timestamp)
                                   file-or-directory-modify-seconds)]
              [#:path-prefix path-prefix (or/c #f path-string?) #f]
              [#:system-type sys-type symbol? (system-type)])
         void?]{

Creates @racket[zip-file], which holds the complete content of all
@racket[path]s.

The given @racket[path]s are all expected to be
relative path names of existing directories and files (i.e., relative
to the current directory).  If a nested path is provided as a
@racket[path], its ancestor directories are also added to the
resulting zip file, up to the current directory (using
@racket[pathlist-closure]).

Files are packaged as usual for
@exec{zip} files, including permission bits for both Windows and Unix
(including Mac OS X).  The permission bits are determined by
@racket[file-or-directory-permissions], which does not preserve the
distinction between owner/group/other permissions. Also, symbolic
links are always followed.

The @racket[get-timestamp] function is used to obtain the modification
date to record in the archive for a file or directory, while
@racket[sys-type] determines the system type recorded in the archive.

If @racket[path-prefix] is not @racket[#f], then it prefixes the name
of each path as it is written in the @exec{zip} file, and directory
entries are added for each element of @racket[path-prefix].

@history[#:changed "6.0.0.3"
         @elem{Added the @racket[#:get-timestamp] and @racket[#:system-type] arguments.}
         #:changed "6.0.1.12"
         @elem{Added the @racket[#:path-prefix] argument.}]}
         


@defproc[(zip->output [paths (listof path-string?)]
                      [out output-port? (current-output-port)]
                      [#:timestamp timestamp (or/c #f exact-integer?) #f]
                      [#:get-timestamp get-timestamp
                                       (path? . -> . exact-integer?)
                                       (if timestamp
                                           (lambda (p) timestamp)
                                           file-or-directory-modify-seconds)]
                      [#:path-prefix path-prefix (or/c #f path-string?) #f]
                      [#:system-type sys-type symbol? (system-type)])
         void?]{

Zips each of the given @racket[paths], and packages it as a zip
``file'' that is written directly to @racket[out].  Unlike
@racket[zip], the specified @racket[paths] are included without
closing over directories: if a
directory is specified, its content is not automatically added, and
nested directories are added without parent directories.

@history[#:changed "6.0.0.3"
         @elem{Added the @racket[#:get-timestamp] and @racket[#:system-type] arguments.}
         #:changed "6.0.1.12"
         @elem{Added the @racket[#:path-prefix] argument.}]}


@defboolparam[zip-verbose on?]{

A parameter that controls output during a @racket[zip]
operation. Setting this parameter to a true value causes @racket[zip]
to display to @racket[(current-error-port)] the filename that is
currently being compressed.}
