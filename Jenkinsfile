ports = [ 81, 82, 83]

pipeline {
    agent {
        node {
            label 'slave2'
        }
    }
    parameters {
    	string(name: 'serverIP', defaultValue: 'None', description: 'Enter target Host IP ')
	string(name: 'targetHost', defaultValue: 'None', description: 'Enter target host for deployment ')
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
	stage('Remove old containers'){
		steps {
			sh "if [ `sudo docker ps -a -q|wc -l` -gt 0 ]; then sudo docker rm -f \$(sudo docker ps -a -q);fi"
		}
	}
	stage('Build deployment image'){
		steps {
			sh "sudo docker build /home/ubuntu/jenkins/workspace/${JOB_NAME} -t ${dockerUser}/devopsdemo"
		}
	}
	stage('Push Image'){
		steps {
			sh "echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login --username ${dockerUser} --password-stdin"
			sh "sudo docker push ${dockerUser}/devopsdemo:latest"
		}
	}
	stage('Deploy website on containers') {
		steps {
			sh  'ansible-playbook docker.yaml -e "hostname=${targetHost}"'
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
