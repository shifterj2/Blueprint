import "systems/vec" for Vec
import "systems/sprite" for Sprite
import "systems/random" for Random

import "systems/director" for Director
import "systems/sound" for Sound

var LocationToCords = Fn.new{|location|
    if (location == -1) {
        return Vec.new(-50000, 0)
    } else if (location == 0) {
        return Vec.new(0, 0)
    } else if ((1..4).contains(location)) {
        var start = 0 - (Num.pi / 4)
        var dif = Num.pi / 2
        var i = location - 1

        var ang = start + dif * i
        var rad = 75

        return Vec.new(ang.cos * rad, ang.sin * rad)
    } else if ((5..12).contains(location)) {
        var start = Num.pi * 3/2
        var dif = Num.pi / 4
        var i = location - 1

        var ang = start + dif * i
        var rad = 125

        return Vec.new(-ang.cos * rad, -ang.sin * rad)
    } else {
        var start = Num.pi * 3/2 + Num.pi / 8
        var dif = Num.pi / 4
        var i = location - 1

        var ang = start + dif * i
        var rad = 175

        return Vec.new(-ang.cos * rad, -ang.sin * rad)
    }
}


class Player {
	location { _location }
	movesLeft { _movesLeft }
	dead {_location==-1}
	roundsWon {_roundsWon}
	roundsWon = (value){
		_roundsWon = value
	}
	win(){
		roundsWon = roundsWon + 1

        if (_num == 0) Sound.playSound("win1.wav")	
        if (_num == 1) Sound.playSound("win2.wav")
	}
	movesLeft = (value){
		_movesLeft = value	
	}
	location = (value){
		_location = value
	}
	points { _points }
	points = (value){
		_points = value	
	}
	addPoints(value){
		_points = _points + value	
	}
	move(target) {
		if(_movesLeft > 0 && _board.nextTo(_location, target)) {
			_location = target
			_movesLeft = _movesLeft - 1
		}
	}

    construct new(i) {
        _location = 0
        _movesLeft = 0
        _num = i
        if (i == 0) _sprite = Sprite.new("white.png")
        if (i == 1) _sprite = Sprite.new("black.png")

        _points = 0
        _roundsWon = 0

        _board = Director.current.board
    }

    reset() {
        _location = 0
        _movesLeft = 0
        _points = 0
    }

	roll() {
		movesLeft = movesLeft + Random.int(6) + 1
        System.print(movesLeft)
	}
	die(){
//         Sound.playSound("die.wav")
		_location = -1 // bye felicia	
	}
	moveEnemy(enemy,target){
		if(movesLeft >= 2 && enemy.location == _location && _board.nextTo(_location, target)){
			enemy.location = target
			_movesLeft = _movesLeft - 2
            Sound.playSound("push.wav")
		}
	}

	playerReset(){
		_location == 0	
	}

    render(i) {
        var pos = LocationToCords.call(_location)
        _sprite.setPosition(pos.x * 2 + 1920/2 - 30 + 60 * i, pos.y * 2 + 1080/2)

        _sprite.render()
    }
}
