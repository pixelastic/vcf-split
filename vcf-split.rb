# encoding : utf-8
require "fileutils"
# Splits a huge `.vcf` file into one for each contact
# Usage :
#  $ vcf-split ./input.vcf {output_dir/}

class VcfSplit
	# Custom exceptions
	class Error < StandardError; end
	class ArgumentError < Error; end
	class FileNotFoundError < Error; end


	def initialize(*args)
		parse_args(*args)

		# Read initial file as string
		@content = File.open(@input_file, "r").read.gsub('\r\n', '\n')
	end

	# Parse args to validate them
	def parse_args(*args)
		unless args.size > 0 
			raise VcfSplit::ArgumentError, "You must specify the input file", ""
		end
		unless File.exists?(args[0]) 
			raise VcfSplit::FileNotFoundError, "Input file not found", ""
		end
		@input_file = args[0]

		# One can specify an output dir, otherwise current dir is used
		@output_dir = args[1] || "./"
		@output_dir = File.expand_path(@output_dir)
		FileUtils.mkdir_p(@output_dir)
	end

	# Splits the input file in multiple smaller files
	def run
		split_vcards(@content).each do |vcard|
			name = File.join(@output_dir, get_vcard_name(vcard)+".vcf")

			# Save the file
			File.open(name, "w") do |file|
				file.write(vcard)
			end
		end

	end

	# Return an array of vcards from a string
	def split_vcards(content)
		buffer = []
		return_array = []

		# Looping through each line to cut each vcard and save it in return_array
		content.each_line do |line|
			buffer << line
			if line.chomp == 'END:VCARD'
				return_array << fix_phone_numbers(buffer.join)
				buffer = []
			end
		end
		
		return return_array
	end

	# Return the contact name from a vcard
	def get_vcard_name(vcard)
		simple_name = /^FN:(.*)\n/
		utf8_name = /^FN;CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:(.*)\n/

		if simple = vcard.match(simple_name)
			return simple[1].chomp
		end

		if utf8 = vcard.match(utf8_name)
			return utf8[1].unpack("M")[0].chomp
		end
	end

	# Make phone numbers of a vCard in a more international format
	def fix_phone_numbers(vcard)
		tel = /^TEL;(.*)(;PREF)?:(.*)/

		vcard.gsub!(tel) do
			"TEL;#{$1}#{$2}:#{$3.gsub('-','')}"
		end

		return vcard
	end

end
