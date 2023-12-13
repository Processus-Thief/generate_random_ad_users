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



function New-RandomPassword {
[CmdletBinding()]
#Switch type of parameter allows us to use just -ParameterName for boolean type of parameters
Param(
    [Parameter()]
    [int]$PasswordLength = 15,
    [Parameter()]
    [switch]$BigLetters,
    [Parameter()]
    [switch]$SmallLetters,
    [Parameter()]
    [switch]$Numbers,
    [Parameter()]
    [switch]$NormalSpecials,
    [Parameter()]
    [switch]$ExtendedSpecials
)
    $asciiTable = $null
    #We are checking if any parameter was provided for function. If not, let's use small leters
    if (!$BigLetters -and !$SmallLetters -and !$Numbers -and !$NormalSpecials -and !$ExtendedSpecials) {
        for ( $i = 97; $i -le 122; $i++ ) {
            $asciiTable += , [char][byte]$i
        }
    }
    if ($Numbers) {
        for ( $i = 48; $i -le 57; $i++ ) {
            $asciiTable += , [char]$i
        }
    }
    #Normal specials have better chance to work in passwords used in some exotic environments
    if ($NormalSpecials) {
        $asciiTable += "*","$","-","+","?","_","&","=","!","%","{","}","/"
    }
    if ($ExtendedSpecials) {
        $asciiTable += "@","#",".",",","^","(",")",":",";","'","`"","~","``","<",">"
    }
    if ($BigLetters) {
        for ( $i = 65; $i -le 90; $i++ ) {
            $asciiTable += , [char]$i
        }
    }
    if ($SmallLetters) {
        for ( $i = 97; $i -le 122; $i++ ) {
            $asciiTable += , [char]$i
        }
    }
    $tempPassword = $null
    for ( $i = 1; $i -le $PasswordLength; $i++) {
        $tempPassword += ( Get-Random -InputObject $asciiTable )
    }
    return $tempPassword
}


foreach ($User in $Users) {

       $Firstname = $User.split(' ')[0]
       $Lastname = $User.split(' ')[1]
       $SAM = $User[0]+$Lastname
       $Displayname = $SAM
       $UPN = $Displayname + "@lab.com"
       $generatedpass = New-RandomPassword -BigLetters -SmallLetters -Numbers -NormalSpecials -PasswordLength 20
       $Password = (ConvertTo-SecureString $generatedpass -AsPlainText -Force)

       New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName "$SAM" -UserPrincipalName "$UPN" -GivenName "$Firstname" -Surname "$Lastname" -AccountPassword $Password -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $true

       Write-Host "Created user: $SAM"
}