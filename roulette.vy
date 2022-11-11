event Eliminated:
    eliminatedPlayer: indexed(address)
    eliminatedTimestamp: uint256

event Survived:
    survivedPlayer: indexed(address)
    survivedTimestamp: uint256

players: public(address[100])
playersLen: public(uint256)
isPlaying: public(HashMap[address, bool])
hasLost: public(HashMap[address, bool])
odds: uint256
playersTurn: uint256
creator: address

@external
def __init__():
    self.playersLen = 0
    self.odds = 0
    self.playersTurn = 0
    self.creator = msg.sender
    self.odds = 5

@external
def setOdds(oneInThisMany: uint256):
    assert oneInThisMany > 0
    assert self.creator == msg.sender
    self.odds = oneInThisMany

@external
def addPlayer(player: address):
    assert player != empty(address)
    assert self.isPlaying[player] == False
    assert self.hasLost[player] == False
    self.players[self.playersLen] = player
    self.playersLen += 1
    self.isPlaying[player] = True

@internal
def lose(player: address):
    assert player != empty(address)
    assert self.isPlaying[player] == True
    assert self.hasLost[player] == False

    # clear players array and isPlaying map
    for i in range(100):
        if i >= self.playersLen: # range() only takes static integers
            break
        self.isPlaying[self.players[i]] = empty(bool)
        self.players[i] = empty(address)
    self.playersLen = 0
    self.playersTurn = 0
    self.hasLost[player] = True

    log Eliminated(player, block.timestamp)

@internal
def random() -> uint256:
    return block.timestamp % self.odds

@external
def play():
    choice: uint256 = self.random()
    nextPlayer: address = self.players[self.playersTurn]
    if choice == 0:
        self.lose(nextPlayer)
    else:
        self.playersTurn += 1
        self.playersTurn = self.playersTurn % self.playersLen
        log Survived(nextPlayer, block.timestamp)
    
@external
def isALoser(player: address) -> bool:
    assert player != empty(address)
    return self.hasLost[player] == True
