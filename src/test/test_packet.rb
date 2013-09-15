
require 'test/unit'
require_relative '../packet.rb'

class TestPacket < Test::Unit::TestCase
	
	def test_initialize_happy_path
		p = Packet.new([1] * 188)
  		assert_equal p.data.length, 188
	end

	def test_initialize_failing_less
  		assert_raises(SizeDataError) do
    		Packet.new([1,2,3,4,5])
    	end
	end

	def test_initialize_failing_more
 		assert_raises(SizeDataError) do
    		Packet.new([1] * 189)
    	end
	end

	def test_get_pid
		p = Packet.new([0x47.chr, 0xe3.chr, 0x1.chr].concat([0] * 185))
		assert_equal p.get_pid, '0001100000001'

		p = Packet.new([0x47.chr, 0xf7.chr, 0x77.chr].concat([0] * 185))
		assert_equal p.get_pid, '1011101110111'

		p = Packet.new([0x47.chr, 0xff.chr, 0xff.chr].concat([0] * 185))
		assert_equal p.get_pid, '1111111111111'

		p = Packet.new([0x47.chr, 0xe0.chr, 0x00.chr].concat([0] * 185))
		assert_equal p.get_pid, '0000000000000'
	end

	def test_is_pat_WHEN_is_PAT
		p = Packet.new([0x47.chr, 0xe0.chr, 0x00.chr].concat([0] * 185))
		assert p.is_pat?
	end

	def test_is_pat_WHEN_not_is_PAT
		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr].concat([0] * 185))
		assert (not p.is_pat?)
	end

	def test_has_pid
		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr].concat([0] * 185))
		assert p.has_pid? 0x10

		p = Packet.new([0x47.chr, 0xe1.chr, 0xff.chr].concat([0] * 185))
		assert p.has_pid? 0x1ff
	end

	def test_no_AF_payload_only
		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x1f.chr].concat([0] * 184))
		assert p.no_AF_payload_only?

		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x5f.chr].concat([0] * 184))
		assert p.no_AF_payload_only?
	end

	def test_no_AF_payload_only
		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x1f.chr].concat([0] * 184))
		assert p.no_AF_payload_only?

		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x5f.chr].concat([0] * 184))
		assert p.no_AF_payload_only?
	end

	def test_get_adapt_field_ctrl
		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x6f.chr].concat([0] * 184))
		assert_equal p.get_adapt_field_ctrl, '10'

		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x5f.chr].concat([0] * 184))
		assert_equal p.get_adapt_field_ctrl, '01'

		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0xff.chr].concat([0] * 184))
		assert_equal p.get_adapt_field_ctrl, '11'

		p = Packet.new([0x47.chr, 0xe0.chr, 0x10.chr, 0x0f.chr].concat([0] * 184))
		assert_equal p.get_adapt_field_ctrl, '00'
	end

end

