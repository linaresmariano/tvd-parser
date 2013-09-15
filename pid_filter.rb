#!/usr/bin/env ruby

require_relative 'src/packet.rb'

# Parser de Transport Streams
def filter_id(source, dest, pids_to_filter_array)

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
			if ts.appear_pid? pids_to_filter_array
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
#pid = 0x0132 # Tecnopolis - audio
#pid = 0x0211 # Tv-Publica One-Seg - video
#pid = 0x0121 # TV-Publica HD - video
#pid = 0x0122 # TV-Publica HD - audio


########################
#######   RUN   ########
########################
if(ARGV.length >= 3)
	src  = ARGV[0]
	dest = ARGV[1]
	pids = ARGV[2..-1].map { |x| Integer(x) }

	#print pid
	filter_id(src, dest, pids)
else
	puts "Wrong number of arguments. At least 3:  source.ts  destination.ts  filter_pid1"
end



