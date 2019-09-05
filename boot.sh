#Stop the background process
sudo /etc/init.d/bluetooth stop
# Turn on Bluetooth
sudo hciconfig hcio up
# Update  mac address
./updateMac.sh
#Update Name
./updateName.sh MiaoMiao_Keyboard
#Get current Path
export C_PATH=$(pwd)
#Create Tmux session
tmux has-session -t  mlabviet
if [ $? != 0 ]; then

    tmux new-session -s mlabviet -n os -d
    tmux split-window -h -t mlabviet
    tmux split-window -v -t mlabviet:os.0
    tmux split-window -v -t mlabviet:os.1
    tmux send-keys -t mlabviet:os.0 'cd $C_PATH && sudo /usr/sbin/bluetoothd --nodetach --debug -p time ' C-m
    tmux send-keys -t mlabviet:os.1 'cd $C_PATH/server && sudo python btk_server.py ' C-m

    tmux send-keys -t mlabviet:os.2 'cd $C_PATH && sudo /usr/bin/bluetoothctl' C-m
    sleep 2
    tmux send-keys -t mlabviet:os.2 'agent on' C-m
    sleep 2
    tmux send-keys -t mlabviet:os.2 'default-agent' C-m
    sleep 2
    tmux send-keys -t mlabviet:os.2 'scan on' C-m
    sleep 2
    tmux send-keys -t mlabviet:os.2 'discovery on' C-m

    tmux send-keys -t mlabviet:os.3 'cd $C_PATH/keyboard/ && sleep 5 && sudo python kb_client.py' C-m
fi
tmux a
