
############################################################
#             CONFIGURATION (kind-of)
############################################################

# PROJECTOR resolution command stuff:

# set EDID resolution for dp1 to WQXGA@60hz (17 is 60hz, 18 is 120hz)
# set EDID resolution for dp1 to WUXGA@60hz (15 is 60hz, 16 is 120hz)
# high res send('EDIR17 25')  or low res send('EDIR15 25')
$dp1_lowres='EDIR15 25' # for 1920x1200
$dp1_highres='EDIR17 25' # for 2560x1600


# set EDID resolution for dp2 to WQXGA@60hz (17 is 60hz, 18 is 120hz)
# set EDID resolution for dp2 to WUXGA@60hz (15 is 60hz, 16 is 120hz)
# high res send('EDIR17 26')  or low res send('EDIR15 26')
$dp2_lowres='EDIR15 26' # for 1920x1200
$dp2_highres='EDIR17 26' # for 2560x1600

# default
$dp1_res = $dp1_highres
$dp2_res = $dp2_highres



############################################################
############################################################


$dir = File.dirname(File.realpath(__FILE__))


require $dir + "/hy_projectors_common"

$prog = File.basename($0)
 
def usage()

    nprojs = $projectorIPs.length
    puts <<EOF

  Usage: #{$prog} [-m|--mono][--low-res][PROJ_WALL ...]|[-h|--help]

   Turn @on@ projectors via the ethernet TCP/IP interface.


   Examples:

          #{$prog}

   will turn @on@ all #{nprojs.to_s} hypercube projectors,


          #{$prog} LT FB

   will turn @on@ the left top (LT) and floor bottom (FB) projectors.

   This program will get options from environment variable
   HYPERCUBE_OPTIONS which will override command line options.


               OPTIONS

    -h|--help         print this help and exit

    -m|--mono         turn projectors on with mono viewing.  Default is stereo

    --low-res         if the X11 server is not running yet this will set the
                      projectors to a low resolution, 1920x1200 pixels.  If
                      the X11 server is running the resolution will be determined
                      automatically, over-riding this option, by asking the X11
                      server.  The other default resolution is 2560x1600 pixels.


   Possible PROJ_WALL values are:

EOF
    print '    '
    $projectorIPs.each { |p,ip| print p + ' ' }
    puts
    puts

    puts <<EOF

    Example, another way using shell command:

        echo -e ":@CMD@\\r" | nc #{$projectorIPs['LT']} 1025

    where the IP addresses (#{$projectorIPs['LT']}) are:

EOF

    $projectorIPs.each { |p,ip| puts '           ' + p + '  ' + ip }
    puts


    exit 1
end

$proj = []
$stereo = true

# debugging commandline
$env = ''
$env =  'HYPERCUBE_OPTIONS=' + ENV['HYPERCUBE_OPTIONS'] + ' ' if ENV['HYPERCUBE_OPTIONS']
puts "\n\n" + $env + $0 + ' ' + ARGV.join(' ')
#######################


def set_lowres()
    $dp1_res = $dp1_lowres
    $dp2_res = $dp2_lowres
end

def parse_arg(arg)
    # lucky this program only has flag-like options
    case arg
        when '--help' then usage
        when '-h' then usage
        when '-m' then $stereo = false
        when '--mono' then $stereo = false
        when '--m' then $stereo = false
        when '-mono' then $stereo = false
        when '-low-res' then set_lowres
        when '--low-res' then set_lowres
        else $proj << arg
    end
end

ARGV.each do |arg|
    parse_arg(arg)
end


# parse options from ENV['HYPERCUBE_OPTIONS'] too
if ENV['HYPERCUBE_OPTIONS']
    puts 'parsing env HYPERCUBE_OPTIONS="' +
        ENV['HYPERCUBE_OPTIONS'] + '"'
    $args = ENV['HYPERCUBE_OPTIONS'].split(' ')
    $args.each do |arg|
        parse_arg(arg)
    end
end

# Now if X11 is running we can query the width of the root window
def checkWidth()
    w = `#{$dir + '/hy_getRootWidth'}`
    w.strip!
    puts 'Found root window width: ' + w
    if w == '1920' # wxh = 1920x1200
        # We must have the same resolution as the X server
        set_lowres()
        puts 'set low res 1920x1200 mode'
    end
    # else we assume it's 2560x1600
end

checkWidth()

if $proj.length == 0
    $projectorIPs.each { |name,ip| $proj << name }
else
    $proj.each do |p|
        if not $projectorIPs[p.upcase]
            puts "Projector \"" + p.upcase + "\" not found."
            usage
        end
    end
end

if '@CMD@' == 'POWR0'
    $mode = 'Off'
elsif $stereo
    $mode = "On in Stereo"
else
    $mode = "On in Mono"
end

puts "\nTurning " + $mode + " the following projectors: " +
    $proj.join(' ') + "\n\n"

# send command to array of projectors
$proj.each { |p| sendToName('@CMD@',p) }


exit unless '@CMD@' == 'POWR1'

# We are turning on projectors so we set all the projectors
# to Stereo or Mono

# set input to display port 1
send('IDIP1')

send($dp1_res)
send($dp2_res)

# display port eq settings (0=normal, 1=high, 2=low)
send('DPE11')
send('DPE21')

# Installation->synchronization
# 2D framelock to source
send('FLSO0') 
# 3D display sync to SYNC1
send('TDLR1')
# 3D display sync to source for first projector in chain
sendToName('TDLR0', 'LT')
# set SYNC1 to input
send('TBO10')
# set SYNC2 to display sync 
send('TBO23')
# set SYNC2 to glasses sync for first projector
sendToName('TBO22', 'LT')
# set SYNC3 to display sync
send('TBO33')
# set SYNC3 to glasses sync for first projector
sendToName('TBO32', 'LT')

# genlock phase delay to 0
send('TDGD0')

# Installation
# image orientation to desktop rear (DESK is desktop front)
send('RDES')
# image orientation to ceiling front (RCEI is ceiling rear)
sendToName('CEIL', 'FT')
sendToName('DESK', 'FB')

# No BARCO splash logo
send('SPLH0')

# Full lamp power (range 0-350). Make floor slightly dimmer to match walls
# These should not change
#sendToName('LPW1350', 'LT')
#sendToName('LPW1350', 'LB')
#sendToName('LPW1350', 'CT')
#sendToName('LPW1350', 'CB')
#sendToName('LPW1350', 'RT')
#sendToName('LPW1350', 'RB')
    
#sendToName('LPW1280', 'FT')
#sendToName('LPW1280', 'FB')



if $stereo

    # 3D 
    # stereo on (1=frame sequential, 2=side-by-side, 3=dual-head)
    send('TDSM3')
    # glasses type: IR (only for F35)
    #TDGT1 ALL
    # swap eyes to 1
    send('TDSE1')

    # 3D->Dual head setup
    # set left eye to display port 1
    send('IABS17 0')
    # set right eye to display port 2
    send('IABS18 1')

else # mono

    # TODO: This

    # stereo (0= off, 1=frame sequential, 2=side-by-side, 3=dual-head)
    send('TDSM0')
    # swap eyes to 0
    send('TDSE0')

end

puts "#{$prog} finished"


# References:

# Projector user guide:
# https://www.barco.com/tde/%280052102360800021%29/TDE6605/00/Barco_UserGuide_TDE6605_00__GP9-platform-LAN-RS232-communication-protocol.pdf

