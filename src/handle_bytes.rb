###################################
###       To handle bytes       ###
###################################

class Bytes

	def self.num_to_s_with_length_in_base(hex_pid, length, base)
		bits = hex_pid.to_s(base)
		return bits[-length, length] if bits.length > length
		return bits.rjust(length, '0')
	end

	# Convierte de hexa a un string de 0s y 1s
	# completando con 0 hasta length o truncando
	def self.binary_string_with_length(hex_pid, length)
		self.num_to_s_with_length_in_base(hex_pid, length, 2)
	end

	def self.to_s2_pid(number)
		self.binary_string_with_length(number, 13)
	end

	def self.s_to_s2(string, length)
		return self.binary_string_with_length(self.value_uint8(string), length)
	end

	def self.s_to_s2_byte(string)
		return self.binary_string_with_length(self.value_uint8(string), 8)
	end

	def self.value_uint8(data)
		return data.unpack("C")[0]
	end

	def self.s2_from_bytes_s(str_list)
		str_list.inject("") {|x, string| x + Bytes.s_to_s2_byte(string) }
	end

	########################
	##       BASE 16    ####
	########################

	def self.s_to_s16(string)
		"0x#{string.to_i(2).to_s(16)}"
	end

	def self.s_to_s16_with_length(string, length)
		"0x#{string.to_i(2).to_s(16).rjust(length, '0')}"
	end

	def self.s_to_s16_byte(byte)
		num_to_s_with_length_in_base(self.value_uint8(byte), 2, 16)
	end

	def self.s16_from_bytes_s(str_list)
		str_list.inject("0x") {|x, string| x + Bytes.s_to_s16_byte(string) }
	end

end
