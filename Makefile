
OSNAME:=ChooseYourLife
IMGNAME:=ChooseYourSelf

run:
	VBoxManage createvm --name $(OSNAME) --ostype Other --register
	VBoxManage storagectl $(OSNAME) --name Floppy --add floppy
	VBoxManage storageattach $(OSNAME) --storagectl Floppy --device 0 --medium $(IMGNAME)
	VBoxManage startvm $(OSNAME)

clean:
	VBoxManage unregistervm $(OSNAME) --delete
