# Run below cmd in powershell first to overcome restrictions to run this powershell 
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted 

# creates a scratch org from the scratch-def file and as mbxSC with a 10days of expiration and finally makes it as defaultusername locally but not globally
sfdx force:org:create -f config/project-scratch-def.json --setalias mbxSC --durationdays 10 --setdefaultusername

# generates a password and returns it
sfdx force:user:password:generate

# Deploy the source metadata into scratch orgs
sfdx force:source:push 

# Assign the user with perm set that already pushed above(metadata)
sfdx force:user:permset:assign -n AdminEssentials
