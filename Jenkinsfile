ports = [ 81, 82, 83]

pipeline {
    agent any
    parameters {
    	string(name: 'serverIP', defaultValue: 'None', description: 'Enter target Host IP ')
		string(name: 'dockerUser', defaultValue: 'None', description: 'Enter Docker user name ')   
    }
    environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    stages {
        stage('SCM checkout'){
        	steps {
				git "https://github.com/vistasunil/jenkins-cicd-webinar.git"
            }
		}
		//stage('Install docker'){
	    //    steps {
		//		sh """
	   	//			sudo apt update -y 
	    //   				sudo apt install docker.io -y
		//    	"""
	    //    }
		//}
		stage('Build deployment image'){
			steps {
				sh "sudo docker build /var/jenkins_home/workspace/${JOB_NAME} -t ${dockerUser}/devopsdemo --no-cache"
			}
		}
		stage('Push Image'){
			steps {
				sh "echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login --username ${dockerUser} --password-stdin"
				sh "sudo docker push ${dockerUser}/devopsdemo:latest"
			}
		}
		stage('Deploy containerized website') {
			steps {
				sh  '''
	                           sudo docker run -tid -p 81:80 ${dockerUser}/devopsdemo:latest
				   sudo docker run -tid -p 82:80 ${dockerUser}/devopsdemo:latest
	      			   sudo docker run -tid -p 83:80 ${dockerUser}/devopsdemo:latest
		        '''
			}
		}
		stage('Test the website') {
			steps {
				test_web(ports,serverIP)
			}
		}
    }
}

def test_web(ports,serverIP) {
    script {
     ports.each { entry ->                        
	    sh "curl -I http://${serverIP}:${entry}"
     }
    //for (int i = 0; i < port.size(); i++) {
    //    sh "curl -I http://34.125.198.147:${port[i]}"
    //}
    }
}
