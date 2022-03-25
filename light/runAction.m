function runAction(backend, action)

    cmd = ['python3 main.py ' backend ' --action ' int2str(action)];

system(cmd);
end