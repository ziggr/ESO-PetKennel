.PHONY: put parse zip doc

put:
	rsync -vrt --delete --exclude=.git \
		--exclude=.gitignore \
		--exclude=.gitmodules \
		--exclude=data \
		--exclude=doc \
		--exclude=published \
		--exclude=save \
		--exclude=tool \
		. /Volumes/Elder\ Scrolls\ Online/live/AddOns/PetKennel

get:
	cp  -f /Volumes/Elder\ Scrolls\ Online/live/SavedVariables/PetKennel.lua     data/
	-cp -f /Volumes/Elder\ Scrolls\ Online/live/SavedVariables/LibDebugLogger.lua data/


getpts:
	cp  -f /Volumes/Elder\ Scrolls\ Online/pts/SavedVariables/PetKennel.lua     data/
	-cp -f /Volumes/Elder\ Scrolls\ Online/pts/SavedVariables/LibDebugLogger.lua data/

zip:
	-rm -rf published/PetKennel published/PetKennel\ x.x.x.zip
	mkdir -p published/PetKennel
	cp ./PetKennel* Bindings.xml published/PetKennel/

	cd published; zip -r PetKennel\ x.x.x.zip PetKennel

	rm -rf published/PetKennel

log:
	lua tool/log_to_text.lua > data/log.txt

doc:
	tool/2bbcode_phpbb  <README.md >/tmp/md2bbdoc
	cp /tmp/md2bbdoc doc/README.bbcode
