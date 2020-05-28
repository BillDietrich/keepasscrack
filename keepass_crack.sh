#!/bin/bash
#------------------------------------------------------------------------------
# keepass_crack.sh


#------------------------------------------------------------------------------
# Change these values to match your files:
# database location
database="test.kdbx"
# Wordlist
wordlist="wordlist.txt"
# Set 1 if you want to crack with keyfiles
keyfilesupport="0"
keylocation="keyfile"


#------------------------------------------------------------------------------
# Don't change anything below here:

hashfilename="$database".hash
rm -f "$hashfilename"
foundpasswordfilename="$hashfilename".password
rm -f "$foundpasswordfilename"


#------------------------------------------------------------------------------
if [ $keyfilesupport -eq "1" ]; then
	john-the-ripper.keepass2john -k "$keylocation" "$database" >"$hashfilename"
else
	john-the-ripper.keepass2john "$database" >"$hashfilename"
fi
cat "$hashfilename"
echo


# Easy way of doing it, no need to run hashcat, un-comment next 4 lines:
#john --wordlist="$wordlist" "$hashfilename"
#john --show "$hashfilename"
#rm -f "$hashfilename"
#exit
# But I suspect it's using hashcat underneath, or at least using the same potfile.


# remove database name and ":" from start of hash file
sed -i "s/[^:]*://" "$hashfilename"
cat "$hashfilename"
echo


#------------------------------------------------------------------------------
# hashcat --help | grep -i "KeePass"
# gives 13400

# --hash-type 13400 => KeePass Hash Provided
# --attack-mode 0 => Dictionary Attack ("Straight")
# --workload-profile 1 => workload profile (Low Latency Desktop Profile)
# add following argument if you want to do a timing run, force compute all hashes
# --potfile-disable => don't remember previously-cracked hashes

# do the actual hashing
hashcat --quiet --force --status --hash-type=13400 --attack-mode=0 --workload-profile=2 "$hashfilename" "$wordlist"

# obtain the password for any hash that matches the needed hash
hashcat --hash-type=13400 --show -o "$foundpasswordfilename" "$hashfilename"

# remove all but password from result file
sed -i "s/[^:]*://" "$foundpasswordfilename"

echo
echo "Password is:"
cat "$foundpasswordfilename"

rm -f "$hashfilename"
rm -f "$foundpasswordfilename"


#------------------------------------------------------------------------------
