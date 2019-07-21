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

# Use sed to replace all my private, local, relative image paths with
# public, global, absolute paths to the same images hosted on esoui.com.
#
# I don't know why 2bbcode is inserting occasional [img=] tags instead
# of [img], but we'll just brute-force sed them away.
#
doc:
	tool/2bbcode_phpbb  <README.md >/tmp/md2bbdoc

	sed sSdoc/img/chat_hide.jpgShttps://cdn-eso.mmoui.com/preview/pvw8263.jpgS /tmp/md2bbdoc >/tmp/md2bbdoc_a ; mv /tmp/md2bbdoc_a /tmp/md2bbdoc
	sed sSdoc/img/key_binding.jpgShttps://cdn-eso.mmoui.com/preview/pvw8264.jpgS /tmp/md2bbdoc >/tmp/md2bbdoc_a ; mv /tmp/md2bbdoc_a /tmp/md2bbdoc
	sed sSdoc/img/settings.jpgShttps://cdn-eso.mmoui.com/preview/pvw8265.jpgS /tmp/md2bbdoc >/tmp/md2bbdoc_a ; mv /tmp/md2bbdoc_a /tmp/md2bbdoc

	cp /tmp/md2bbdoc doc/README.bbcode
