gems:
	which gs  || gem install gs
	which dep || gem install dep
	dep add cuba
	dep add mote
	dep add cuba-contrib
	dep add rack-protection
	dep add shield
	gs init

install:
	dep install
