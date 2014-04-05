self.addEventListener('message', function(e) {
    var data = e.data;

    switch(data.cmd) {
        case 'start':
            self.postMessage('Worker started: ' + data.msg);
            break;
            break;
        case 'stop':
            self.postMessage('Worker stopped: ' + data.msg);
            self.close();
            break;
        default:
            self.postMessage('unkown command: ' + data.msg);
    }
}, false);
