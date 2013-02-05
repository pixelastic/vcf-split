# encoding : utf-8
require 'test/unit'
require_relative '../vcf-split'

class VcfSplitTest < Test::Unit::TestCase

	def setup
		@test_dir = File.dirname(__FILE__)
		@data_dir = File.join(@test_dir, "data")
		@bogus_file = File.join(@test_dir, "bogus.vcf")

		@group_file = File.join(@data_dir, "Group.vcf")
		@alice_file = File.join(@data_dir, "Alice.vcf")
		@bob_file = File.join(@data_dir, "Bob.vcf")

		@instance = VcfSplit.new(@group_file)

		@group = File.open(@group_file).read
		@alice = File.open(@alice_file).read
		@bob = File.open(@bob_file).read


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


	def test_split_vcard
		# Split a big vcard string in an array of vcards strings
		result = @instance.split_vcards(@group)
		expected = [@alice, @bob]
		assert_equal(result, expected)
	end

	def test_get_vcard_name
		result = @instance.get_vcard_name(@alice)
		expected = "Alice"
		assert_equal(result, expected)
	end

	def test_fix_phone_number
		alice_bad = File.open(File.join(@data_dir, "Alice-bad-phone.vcf")).read
		alice_good = File.open(File.join(@data_dir, "Alice-good-phone.vcf")).read

		result = @instance.fix_phone_numbers(alice_bad)
		expected = alice_good
		assert_equal(result, expected)
	end


end
