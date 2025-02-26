function PlayCuttingSound()
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile = 'cutting.mp3',
        transactionVolume = 0.8
    })
end