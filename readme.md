OVERVIEW
--------

`vcf-split` is a simple ruby script that takes a `.vcf` file as input and
splits it in several `.vcf` files, one for each contact saved in the original
file.

This is currently quite rough but serves my purpose.

USAGE
-----

	ruby vcf-split input.vcf

You can also add a second argument to specify the directory where you want the
files, like `ruby vcf-split input.vcf ./output`
