#!/usr/bin/env ruby

require_relative 'src/packet.rb'
require_relative 'src/pat.rb'

# Parser de Transport Streams
def get_services_from_pat(source)

	byte_synch = 'G'

	# Abro el archivo de origen con encoding ASCII-8BIT
	File.open(source, 'rb') do |file|

		# Buscar el byte de sincronizacion
		# Asumo que es el primero que aparece
		until file.read(1) == byte_synch
			return if file.eof?
		end

		# Revisar los paquetes de 188 bytes buscando primera PAT
		begin
			ts = Packet.new(byte_synch + file.read(187))
			
			# Si encuentro la primer PAT sin AF, extraigo los servicios y termino
			if (not ts.has_error?) and ts.is_pat? and ts.no_AF_payload_only? and ts.is_start_payload?

				# Imprime los servicios de una PAT que solo tiene Payload y Start en 1
				PAT.new(ts.get_payload).print_services

  				return
			end

			# Termino si el siguiente paquete no esta sincronizado
  			return if not file.read(1) == byte_synch

		end until file.eof?
	end
end




########################
#######   RUN   ########
########################
if(ARGV.length == 1)
	src  = ARGV[0]
	
	get_services_from_pat(src)
else
	puts "Espero 1 argumento:  source.ts "
end
