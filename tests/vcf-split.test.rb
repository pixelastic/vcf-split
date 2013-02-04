# encoding : utf-8
require 'test/unit'
require_relative '../vcf-split'

class VcfSplitTest < Test::Unit::TestCase

	def setup
		@test_dir = File.dirname(__FILE__)
		@bogus_file = File.join(@test_dir, "bogus.vcf")

	end

	def test_no_input_file
		assert_raise VcfSplit::ArgumentError, "No input file" do
			VcfSplit.new()
		end
	end

	def test_input_file_not_found
		assert_raise VcfSplit::FileNotFoundError, "Input file not found" do
			VcfSplit.new(@bogus_file)
		end
	end


end
