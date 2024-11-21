Add-Type -AssemblyName System.Windows.Forms

# Load the actions and things from text files
$actions = Get-Content -Path "actions.txt"
$things = Get-Content -Path "things.txt"

# Function to generate meme
function Generate-Meme {
    # Randomly select one action and one thing
    $action = $actions | Get-Random
    $thing = $things | Get-Random

    # 25% chance to add "...again!" to the meme, else append "!"
    $meme = "HELP! I accidentally $action $thing"
    $chance = Get-Random -Minimum 1 -Maximum 5  # Random number between 1 and 4

    if ($chance -eq 1) {
        # 25% chance: add "...again!"
        $meme += " ...again!"
    } else {
        # 75% chance: add "!"
        $meme += "!"
    }
    return $meme
}

# Function to show the message box with Retry and Cancel options
function Show-RetryCancelDialog {
    $meme = Generate-Meme
    $memeWithInstruction = "$meme`n`nPress Ctrl + C to copy the meme!"

    $result = [System.Windows.Forms.MessageBox]::Show(
        $memeWithInstruction, 
        "HELP! I accidentally made a meme generator!", 
        [System.Windows.Forms.MessageBoxButtons]::RetryCancel,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )

    if ($result -eq [System.Windows.Forms.DialogResult]::Retry) {
        Show-RetryCancelDialog  # Retry to generate another meme
    } elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
        Write-Host "Exiting..."
        Exit
    }
}

# Show the dialog box when the script runs
Show-RetryCancelDialog
