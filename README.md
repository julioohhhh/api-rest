A minha ideia de implementação principal é que a aplicação rode em um ambiente AWS ECS, onde o build e deploy seja feito
via Jenkins, com os parâmetros informados na execução do job.
	O Jenkins clonaria o ambiente através deste repositório do Github, faria o build e deploy através do script "build-and-deploy.sh".
No build seria construído o pacote da aplicação via comandos maven, após isso seria feito o build da imagem docker e adicionado o pacote da aplicação (.jar), após isso a imagem seria enviada para algum repositório, que pode ser um repositório ECS ou Docker hub por exemplo.
    Após a imagem ser enviada para um repositório é feito o deploy, substituindo a imagem em execução no AWS ECS

Soluções implementadas
- Será criada uma instância ec2 e adicionada a um cluster ECS
- Será criada uma instância ec2 que irá se desligar após o comando sleep
- Arquivos de configuração para criar pods (Aplicação e MySQL)
- Arquivo para subir a aplicação via docker compose
- Script para realização do build e deploy


Melhorias
- Poderia ter algo voltado para a segurança da aplicação. Não há nada implementado neste sentido.
