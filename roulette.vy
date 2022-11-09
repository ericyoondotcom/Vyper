event Eliminated:
    address: indexed(address)
    timestamp: uint256

players: public(address[100])
playersLen = public(uint256)
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

@external
def setOdds(oneInThisMany: uint256):
    assert oneInThisMany > 0
    assert self.creator == msg.sender
    self.odds = oneInThisMany

@external
def addPlayer(player: address):
    assert player != empty(address)
    assert !self.isPlaying[player]
    assert !self.hasLost[player]
    self.players[self.playersLen] = player
    self.playersLen += 1
    self.isPlaying[player] = True

@internal
def lose(player: address):
    assert player != empty(address)
    assert self.isPlaying[player]
    assert !self.hasLost[player]
    self.players = empty(address[100])
    self.playersLen = 0
    self.isPlaying = empty(HashMap[address, bool])
    self.losers[player] = True

@internal
def random() -> uint256:

@external play():

@external isALoser(player: address) -> bool:
    assert player != empty(address)
    return 
