
require_relative 'handle_bytes.rb'

###################################
###   Transport Stream packet   ###
###################################

class Packet

	attr_reader :data

	PAT = Bytes.to_s2_pid 0x00
	NIT = Bytes.to_s2_pid 0x10
	SDT = Bytes.to_s2_pid 0x11 
	NUL = Bytes.to_s2_pid 0x1fff
	DATA_SIZE = 188

	def initialize(buffer)
		raise SizeDataError.new if not buffer.length == DATA_SIZE
		@data = buffer
	end

	def get_header
		#Bytes.s2_from_bytes_s(@data[1..2])
		Bytes.s2_from_bytes_s([@data[1], @data[2]])
	end

	# Extraer el PID del header (primeros dos bytes)
	def get_pid
		get_header[3..-1]
	end

	def has_error?
		get_header[0].eql? '1'
	end

	def get_payload_unit_start_indicator
		get_header[1]
	end

	def is_start_payload?
		get_payload_unit_start_indicator.eql? '1'
	end

	def has_pid?(pid_search_hex)
		self.get_pid.eql? Bytes.to_s2_pid(pid_search_hex)
	end

	def get_adapt_field_ctrl
		afc_cc = Bytes.s_to_s2(self.data[3], 6)
		return afc_cc[0..1]
	end

	def no_AF_payload_only?
		get_adapt_field_ctrl.eql? '01'
	end

	def is_pat?
		PAT == get_pid
	end

	# PREC: packet has not AF, payload only
	def get_payload
		return @data[4..-1]
	end

end


class SizeDataError < Exception
  def initialize()
    super("Error, data must have length of 188")
  end
end