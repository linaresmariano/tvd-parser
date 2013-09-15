
require_relative 'handle_bytes.rb'

######################################
#####         PAT Payload        #####
######################################

class PAT

	BITS_FIXED_AFTER_LENGTH = 16 + 24 + 32
	# Bits de program_number + reserved + program_map_PID
	CANT_BITS_PROGRAM = 32

	def initialize(payload)
		@data = payload
	end

	# Cantidad de servicios
	def get_service_count
		(get_section_length - BITS_FIXED_AFTER_LENGTH) / CANT_BITS_PROGRAM
	end

	# Cantidad de bits a partir del section_length
	def get_section_length
		length_binary = Bytes.s2_from_bytes_s([@data[1], @data[2]])[4..-1]
		return length_binary.to_i(2)
	end

	# Devuelve el la informacion de un programa ubicado en el index
	# Donde Info de un programa incluye:
	# program_number(16bits), reservados(3bits), program_pid(13bits)
	def get_program(index)
		init = 9 + (index * 4)
		@data[init, init+4]
	end

	# Devuelve el numero del programa que aparece en la posicion index
	def get_program_number(index)
		program = get_program(index)
		Bytes.s16_from_bytes_s([program[0], program[1]])
	end

	# Devuelve el id del servicio que aparece en la posicion index
	def get_network_PID(index)
		program = get_program(index)
		binary_tail_program = Bytes.s2_from_bytes_s([program[2], program[3]])
		network_pid = binary_tail_program[3..-1]

		Bytes.s_to_s16_with_length(network_pid, 4)
	end

	# Imprime los servicios en consola de forma amigable
	def print_services
		# Cantidad de servicios
		service_count = get_service_count

		puts '______________________________________________________'
		puts "|                   SERVICES: #{service_count}                      |"
		puts '|____________________________________________________|'


		# Obtener cada servicio + network
		(0...service_count + 1).each { |index|
			program_number = get_program_number(index)
			network_PID = get_network_PID(index)

			if(index == 0)
				# Es el Network PID
				puts "|  program_number: #{program_number} | network_PID    : #{network_PID}  |"
			else
				# Es el program_map_PID
				puts "|  program_number: #{program_number} | program_map_PID: #{network_PID}  |"
			end
		}

		puts '|____________________________________________________|'
		puts ''
	end
end