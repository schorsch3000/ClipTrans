# ClipTrans

`cliptrans.sh` will Transform the content of your clipboard with a chosen transformer.

A Transformer is an executeble named `transform` in a subdirectory of `./transformers/` that takes input from stdin and outputs to stdout

Shipped Transformers are:

 - html2pug: converts html (eg. from documentation) tu pug (eg. for usage in your template)
 - plaintext: enforces plaintext onto your clipboard
 - string2html: converts to json
 - trim: trims eg: " foo " => "foo"

cliptrans uses rofi as a chooser. Every parameter given to cliptrans will be appended to rofi.

Every transformer should be useable without prior setup, if a transformer needs setup like html2pug, setup should be done on invokation