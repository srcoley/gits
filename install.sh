# Install Gits
#
# Moves gits files to ~/.gits
# Sources the gits.sh file in the .bash_profile file

mv -f ../gits/ ~/.gits
echo ". ~/.gits/gits.sh" >> ~/.bash_profile
