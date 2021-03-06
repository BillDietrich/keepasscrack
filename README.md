# keepasscrack

Simple KeePass password manager database cracker using wordlist (dictionary).  Linux-only.

Does not work on KDBX 4.0 format database.  Does work on KDBX 3.1 format.

May be useful if you forget which keyfile you used, or mixed up a few characters in a password.

When done, use 'wipe' or 'srm' to securely overwrite your wordlist.

Good luck recovering.


## How to run

### Install and test

On Ubuntu, through Ubuntu Software application, install snap version of "John the Ripper CE".  Deb version in repo apparently doesn't have the utility we need (keepass2john).

```shell
# This takes around 500 MB of disk space !
# There is a way to run without invoking hashcat, see "Alternative method"
# section below.  But I am guessing that John the Ripper either uses hashcat
# underneath, or at least shares the same potfile with it.
sudo apt install hashcat

chmod u+x keepass_crack.sh

# Make sure you have the software installed:
john-the-ripper --help
hashcat --version

# To check that everything works correctly, run script with default values
# (against KeePass test.kdbx), it shouldn't take more than 1 minute.
./keepass_crack.sh
# You should see hash extracted from KeePass database, then hashcat
# running for a while, then (if found) matching password displayed at end.
# Spoiler: password for test database is "1234".
```

You can adjust the "workload-profile" of hashcat, which specifies how much of a load it will put on the system.  By default it is set to 2 ("Noticeable").

On my slow laptop, with workload-profile set to 1 ("Minimal"), and correct password on line 207 of wordlist.txt, no keyfile, it took 48 seconds.  So about 4 hashes per second, which I'm sure is pathetic.  With workload-profile set to 2, it took 38 seconds, about 5 hashes/second.  I see users with powerful systems talking about doing hundreds of hashes per second, although they're probably not doing the same algorithm.

Hashcat remembers previously computed hashes, so if you run it again with same or expanded wordlist, it will run much faster (won't re-compute hashes for passwords it's already hashed).


### Alternative method

After implementing the hashcat method, I found (in https://bytesoverbombs.io/cracking-everything-with-john-the-ripper-d434f0f6dc1c) that John The Ripper can do everything by itself (at least for dictionary attacks), no need to use hashcat.

In keepass_crack.sh, un-comment the 4 lines after "Easy way of doing it" and run again.  Takes about 60 seconds on my machine, so not much slower than hashcat with workload-profile set to 1.


### Run for real against your database

Edit keepass_crack.sh to change 4 filenames and values in first section to match your filenames.

Edit wordlist.txt (or whatever wordlist file you specify) to contain values that might work for your database.

If you have powerful hardware, or even just a GPU at all (I don't), you might want to add some arguments to the first hashcat line (the one that's doing the hashing) in keepass_crack.sh  Maybe remove --force and see what hashcat says.  I have no experience with this.

```shell
./keepass_crack.sh
# You should see hash extracted from KeePass database, then hashcat
# running for a while, then (if found) matching password displayed at end.
```

Wordlist/dictionary attacks are the simplest way of using hashcat; it has a bazillion other options.  You can tweak the arguments to hashcat in keepass_crack.sh as you wish.

Also you could try much bigger wordlists from the internet (e.g. from https://github.com/danielmiessler/SecLists/tree/master/Passwords or https://www.openwall.com/wordlists/).


## Limitations

* Linux-only.
* Tested only on Ubuntu desktop GNOME 20.04 with 5.4 kernel.
* Tested only on databases generated by KeePassXC on Ubuntu.


## To-do

* Test with keyfile.
* Test on older KeePass database format.


## Notes

Inspired by https://github.com/BillDietrich/veracryptcrack

Used info in https://www.rubydevices.com.au/blog/how-to-hack-keepass with some changes.

Also useful: https://resources.infosecinstitute.com/hashcat-tutorial-beginners/

https://www.openwall.com/john/

https://github.com/magnumripper/JohnTheRipper/

Potentially this project could be modified to crack anything else where you know the hash or where John The Ripper can extract a hash (e.g. Linux /etc/shadow file, RAR, 7Z, etc).  Also there is a Pro version of John The Ripper, I don't know what it can do.

Also see: https://github.com/haydn-jones/keepass_crack

Also see: https://github.com/imthoe/python-keepass

Also see: https://github.com/abcarroll/keepass-simple-crack-kit


## Privacy Policy

This code doesn't collect, store or transmit your identity or personal information in any way.

