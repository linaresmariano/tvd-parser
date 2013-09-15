#!/usr/bin/env ruby

require_relative 'src/packet.rb'

# Parser de Transport Streams
def filter_id(source, dest, pid_to_filter)

	byte_synch = 'G'
	filtrados = 0

	output = File.open(dest, 'w')

	# Abro el archivo de origen con encoding ASCII-8BIT
	File.open(source, 'rb') do |file|

		# Buscar el byte de sincronizacion
		# Asumo que es el primero que aparece
		until file.read(1) == byte_synch
			return if file.eof?
		end

		puts "Encontre el byte-synch....."
		puts "PROCESANDO PAQUETES..."

		# Revisar los paquetes de 188 bytes buscando el PID
		begin
			begin
				ts = Packet.new(byte_synch + file.read(187))
			rescue SizeDataError
				# Cantidad de datos insuficientes para llenar un paquete
				return
			end
			
			# Si encuentro el PID guardo el paquete en el archivo destino
			if ts.has_pid? pid_to_filter
				filtrados += 1
  				output.write(ts.data)
			end

			# Termino si el siguiente paquete no esta sincronizado
  			return if not file.read(1) == byte_synch

		end until file.eof?
	end

ensure
	puts "## END ## PAQUETES FILTRADOS: #{filtrados}"
	output.close
end


#pid = 0x00 # PAT
#pid = 0x0131 # Tecnopolis - video
#pid = 0x0211 # Tv-Publica One-Seg - video
#pid = 0x0121 # TV-Publica HD - video
#pid = 0x0122 # TV-Publica HD - audio


########################
#######   RUN   ########
########################
if(ARGV.length == 3)
	src  = ARGV[0]
	dest = ARGV[1]
	pid  = Integer(ARGV[2])

	filter_id(src, dest, pid)
else
	puts "Espero 3 argumentos:  source.ts  destination.ts  filter_pid"
end



