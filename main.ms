// Matr template code, delete/update as needed
Experience Main {
    // Add your attributes here
    String userName label("Username")
    String msg label("Mensage")
    Decision r2 action("MainContext.ruleSubscribe") label("subscribe")
    Decision r3 action("MainContext.ruleUnsubscribe") label("unsubscribe")
    Decision r4 action("MainContext.rulePublish") label("publish")
    //Decision r5 action("MainContext.ruleDisconnect") label("disconnect")
    Array<String> messages value([]) as List
}
Application{
    String topicName
    Bool suscribed
    OnInit{
        topicName = "mensajeria"// nombre del canal creado anteriormente 
        broker.async.initialize()
        broker.async.connect()
        broker.async.subscribe(topicName, @function(Subscriptors.handler))
        suscribed = true
    
    }
}

RuleContext MainContext {
    Rule ruleSubscribe{
    
        if(suscribed){
        
            Main m = broker.ui.getDataSource()
            broker.async.subscribe(topicName, @function(Subscriptors.handler))
            suscribed = true
        
        } else { 
        
            broker.ui.showAlert("Warning", "You have to suscribe to the channel first.")
        }
    }
    Rule rulePublish{
    
    
        if(suscribed){
        
            Main main = broker.ui.getDataSource()
            User u = User(name:main.userName)
            Message m = Message(user:u, msg:main.msg)
            broker.async.publish(topicName, m)
    
        } else { 
        
            broker.ui.showAlert("Warning", "You have to suscribe to the channel first.")
        }
    }
    
    Rule ruleUnsubscribe{
        
        if(suscribed){
        
            Main m = broker.ui.getDataSource()
            broker.async.unsubscribe(topicName)
            suscribed = false
        } 
        
    }
    
//    Rule ruleDisconnect{
//        broker.async.disconnect()
//    }


//    Rule ruleConnect{
//        broker.async.connect()
//    }


}



Module Subscriptors{
    void handler(Message message){
        Main m = broker.ui.getDataSource()
        m.messages.add("De " + message.user.name + ": " + message.msg)
    }
}