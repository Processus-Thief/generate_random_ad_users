Import-Module ActiveDirectory

$Users = @(
'Fernand Jacquier',
'Matthias Sylvestre',
'Loïc Jauffret',
'Thibault Beauregard',
'Joseph Riqueti',
'Hector Allaire',
'Samuel Sardou',
'Colin Delsarte',
'Jean-Noël Figuier',
'Lilian Deschanel',
'Frank Lahaye',
'Henry Baugé',
'Ernest Gaudreau',
'Émeric Robineau',
'Constantin Gribelin',
'Gaston Chardin',
'Remy Corriveau',
'Philippe Du Toit',
'Maximilien Jacquinot',
'Florentin Beaulne',
'Aymeric Brazier',
'Roger Corne',
'Timothé Auguste',
'Pascal Barbeau',
'Ange Côté',
'Gaston Besson',
'Laurent Coulomb',
'Cyrille Aliker',
'Barthélemy Droz',
'Boniface Loupe',
'Dimitri Beaulieu',
'Côme Dubuisson',
'Mathis Allard',
'Gaétan Mignard',
'William Jacquet',
'Théo Poussin',
'Théodore Carrell',
'Hubert Gaudreau',
'Alain Chéreau',
'Franck Lambert'
)


$users | Foreach-Object {
       $Prenom = $_.split(' ')[0]
       $Nom = $_.split(' ')[1]
       $ProfileName = $_[0]+$Nom


foreach ($User in $Users) {

       $Firstname = User.split(' ')[0]
       $Lastname = Usersplit(' ')[1]
       $SAM = User[0]+$Nom
       $Displayname = SAM
       $OU = "OU=Users,DC=lab,DC=local"
       $UPN = $Displayname + "@lab.com"
       $generatedpass = -join ((97..122) | Get-Random -Count 10 | ForEach-Object {[char]$_})
       $Password = (ConvertTo-SecureString $generatedpass -AsPlainText -Force)

       New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName "$SAM" -UserPrincipalName "$UPN" -GivenName "$Firstname" -Surname "$Lastname" -AccountPassword $Password -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false -PasswordNeverExpires $true

       Write-Host "Created user: $SAM"
}