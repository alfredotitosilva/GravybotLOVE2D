-- biblioteca de animação
local anim8 = require "anim8"
local image, animation

--universais



function love.load()
	--pra menu do jogo recebe um
	telas_jogo=1
	--ONDE O EFEITO DA GRAVIDADE PARA
	jogadorpisoY=572


	a_pulo=30--aceleração do pulo
	ini_gravidade=200--gravidade inicial

	--USADA PARA CRIAR A PLATAFORMA
	plataformas={}
	ult_plataformas=1000
	---
	ac_obs=5--para acelerar o jogo
	cooldown=1000--para acelerar o jogo a cada 1000
	soma=0--calcula a pontuação

	gravidade=100--gravidade

	--VARIAVEIS RELACIONADA AO JOGADOR
	jogador={x=500,
	y=572,
	r=50,
	pulando= false,
	acel= a_pulo,
	img = nil,
	teste="baixo"--teste o estado da gravidade
	}

	--TESTE DE COLISÃO
	coll=false
	--SOM
	bgm = love.audio.newSource("icons/daftpunk.mp3", "stream")
	initial = love.audio.newSource("icons/genesis.mp3", "stream")
	perca = love.audio.newSource("icons/somperca.mp3","static")
		
	---
	nome = love.graphics.newImage("icons/nome.png")
	space = love.graphics.newImage("icons/space.png")
	ins = love.graphics.newImage("icons/ins.png")
	---
	perdeu = love.graphics.newImage("icons/final.png")
	---
	fundo = love.graphics.newImage("back/b5.png")
	fundo_x=0 --posição inicial do fundo1
	fundo2_x=1281 --posição inicial do fundo2

	
	
	jogador.img = love.graphics.newImage('icons/robot.png')
    local g1 = anim8.newGrid(101, 100, jogador.img:getWidth(), jogador.img:getHeight())
    jogador_up = anim8.newAnimation(g1('1-8',1), 0.08)--animação normal
    jogador_down = anim8.newAnimation(g1('1-8',2), 0.08)--animação invertida

    jogador.altura=100
    jogador.largura=101
    jogador_atual=jogador_up

    --piso do chão
    piso1 = love.graphics.newImage("back/piso1.png")
	piso1x=0
	piso2x=1200
	
	--piso do teto
	piso2 = love.graphics.newImage("back/piso2.png")
	piso_img=piso1

	piso_y1=-220
	piso_y2=572
	
	enemy = love.graphics.newImage('icons/enemy.png')
    local g2 = anim8.newGrid(70,60, enemy:getWidth(), enemy:getHeight())
    animation = anim8.newAnimation(g2('1-9',1), 0.1)
	
end

--FUNÇÃO QUE CHECA COLISÃO COM AS PLATAFORMAS
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

--começa o loop do jogo
function love.update(dt)
	
	if telas_jogo==1 then
		--SOM
		love.audio.play(initial)
		--FUNDO
		fundo_x=fundo_x-5
		fundo2_x=fundo2_x-5	
		
		if fundo_x<-1281 then
			fundo_x=1274
		end
		if fundo2_x<-1281 then
			fundo2_x=1274
		end

	    ---------------
	   	--REINICIO DAS VARIAVEIS DO JOGO

		jogador.x=500
		jogador.y=572
		jogador.teste="baixo"
		
		ult_plataformas=1000

		ac_obs=5

		for i, plataformas in ipairs (plataformas) do
			table.remove(plataformas,i)	
			plataformas.x=-1300	
		end
		----------------
		--INICIANDO JOGO
		if love.keyboard.isDown('space') then
	    	telas_jogo=2
	    end
	end



	if telas_jogo==2 then
		--ANIMAÇÕES
		jogador_atual: update(dt)
	    animation: update(dt)
	    --SOM
	    love.audio.play(bgm)
	    love.audio.stop(initial)

	   -------------
		
	   --ACELERAÇÃO DOS OBSTACULOS
	   cooldown=cooldown-1

	   if cooldown==0 then
	   	ac_obs=ac_obs+2
	   	cooldown=500
	   end

	   soma=soma+1

	   ------------
	  

		coll=false

		
		--MOVIMENTAÇÃO DO CENÁRIO E DO CHÃO,VALORES DIFERENTES PARA QUE OCORRA PARALAXE
		--FUNDO
		fundo_x=fundo_x-5
		fundo2_x=fundo2_x-5	
		
		if fundo_x<-1281 then
			fundo_x=1274
		end
		if fundo2_x<-1281 then
			fundo2_x=1274
		end 

		--PISO 1
		piso1x=piso1x-8
		piso2x=piso2x-8

		if piso1x<-1300 then
			piso1x=1100
		end

		if piso2x<-1300 then
			piso2x=1100
			
		end
		
		--BOTÃO DE PULO
		if love.keyboard.isDown('a') and (jogador.pulando == false) then
			jogador.pulando = true --VERIFICA QUANDO O BONECO ESTÁ EM CONTATO COM O CHÃO OU NÃO
		end

		--JOGADOR ESTÁ PULANDO PARA CIMA
		if jogador.teste == "baixo" then
			if jogador.pulando and jogador.acel>0 then
				jogador.y = jogador.y - jogador.acel --NO EIXO Y RECEBE UM DECRESCIMO NA POSIÇAO Y
				jogador.acel = jogador.acel -1 --A REDUÇAO DA ACELERAÇÃO FAZ COM O JOGADOR CAIA GRADUALMENTE
			end

		end

		--JOGADOR ESTÁ PULANDO COM GRAVIDADE INVERTIDA
		if jogador.teste == "cima" then
			if jogador.pulando and jogador.acel>0 then
				jogador.y = jogador.y + jogador.acel --NO EIXO Y RECEBE UM ACRESCIMO NA POSIÇAO Y
				jogador.acel = jogador.acel -1 
			end
		end
		
		--COMANDOS PARA CONTROLAR A GRAVIDADE
		if love.keyboard.isDown('w') then
			jogador.teste="cima"
			
		end

		if love.keyboard.isDown('s') then
			jogador.teste="baixo"
			
		end



		--COMPORTAMENTO DA GRAVIDADE QUANDO PARA BAIXO
		if jogador.teste == "baixo" then
			
			jogador_atual=jogador_up --MUDANÇA DA ANIMAÇÃO	
				
					jogadorpisoY=572 
			
				if jogador.y < jogadorpisoY then --QUANDO A POSIÇÃO DO JOGADOR NO Y É MENOR QUE O CONTATO COM O CHÃO
					jogador.y = jogador.y + gravidade*dt --O JOGADOR SOFRE UMA SOMA GRADATIVA DA VARIAVEL GRAVIDADE
					gravidade = gravidade + 10
				end

				if jogador.y > jogadorpisoY then --PARA IMPEDIR QUE O JOGADOR ULTRAPASSE O CHÃO
					jogador.y = jogadorpisoY
				end

				if (jogador.y == jogadorpisoY) then --INFORMA QUE O JOGADOR JÁ ESTÁ EM CONTATO COM O CHÃO NOVAMENTE
					jogador.pulando = false
					jogador.acel = a_pulo
					gravidade= ini_gravidade
				end
		end
		
		--COMPORTAMENTO DA GRAVIDADE QUANDO PARA CIMA
		if jogador.teste == "cima" then
				jogador_atual=jogador_down	
					--gravidade

					jogadorpisoY=120

				if jogador.y > jogadorpisoY then --QUANDO O JOGADOR NO Y É MAIOR QUE O PISO
					jogador.y = jogador.y - gravidade*dt --COMO ESTÁ INVERTIDO ELE SOFRE UM DECRESCIMO DA GRAVIDADE,POIS ELA ESTÁ VINDO DE BAIXO PARA CIMA
					gravidade = gravidade + 10
				end

				if jogador.y < jogadorpisoY then
					jogador.y = jogadorpisoY -- PARA IMPEDIR QUE O JOGADOR ULTRAPASSE O PISO TETO
				end

				if jogador.y == jogadorpisoY then --INFORMA QUE O JOGADOR JÁ ESTÁ EM CONTATO COM O PISO TETO NOVAMENTE
					jogador.pulando = false
					jogador.acel = a_pulo
					gravidade= ini_gravidade
				end
		end	


		--GERANDO PLATAFORMAS
		--QUANTO MAIOR O NUMERO MAIS OBSTACULOS,QUANTO MENOR MENOS OBSTACULOS
		ult_plataformas = ult_plataformas - 8 --CAUSA UMA VARIAÇÃO NA QUANTIDADE DE OBSTACULOS GERADOS
		
		if ult_plataformas <=0 then
			ult_plataformas= love.math.random(200,700)

			nova_plataforma ={x=1300, y=math.random(500,jogadorpisoY), largura=25, altura=27}

			table.insert(plataformas,nova_plataforma)
		end
		
		for i, plataformas in ipairs (plataformas) do
			plataformas.x = plataformas.x-(5+ac_obs) -- VELOCIDADE DAS PLATAFORMAS

			--REMOVE AS PLATAFORMAS QUE JÁ SAÍRAM DA TELA
			if plataformas.x<0 then
				table.remove(plataformas,i)
			end

		
		end	

		--TESTE DA COLISÃO COM OS PONTOS
		for i, plataformas in ipairs(plataformas) do
			if CheckCollision(jogador.x,jogador.y,jogador.largura,jogador.altura,plataformas.x,plataformas.y,plataformas.largura,plataformas.altura) then
					coll = true
					--jogador.x= jogador.x - 20 -- JOGADOR SOFRE UM EMPURRÃO DOS OBSTACULOS

						jogador.x= jogador.x - 20		
			end
		end
	end

		
end
--termina e repete

function love.draw( )
	if telas_jogo==1 then
		love.graphics.draw(fundo, fundo_x, 0)
		love.graphics.draw(fundo, fundo2_x, 0)

		love.graphics.draw(nome, 120,200,0,0.8)
		love.graphics.draw(space, 200,400,0,0.7)
		love.graphics.draw(ins, 150,500,0,1.2)

	end 	
	if telas_jogo==2 then
	--desenhando fundo	
		love.graphics.setColor(255,255,255)
		love.graphics.draw(fundo, fundo_x, 0)
		love.graphics.draw(fundo, fundo2_x, 0)


	--desenhando chão
		love.graphics.setColor(255,255,255)
			
			--chao para baixo
			love.graphics.draw(piso1, piso1x, 572+(jogador.altura-1))
			love.graphics.draw(piso1, piso2x, 572+(jogador.altura-1))
			--chão para cima
			love.graphics.draw(piso2, piso1x, -220+(jogador.altura-1))
			love.graphics.draw(piso2, piso2x, -220+(jogador.altura-1))
			
		
	--desenhando o jogador
		love.graphics.setColor(255,255,255)
		
		jogador_atual:draw(jogador.img,jogador.x,jogador.y)
	
	--desenhando plataformas
		for i,plataformas in ipairs(plataformas) do
			love.graphics.setColor(255,255,255)
			animation:draw(enemy,plataformas.x-65,plataformas.y)
		end	
	---SISTEMA DE PONTUAÇÃO
			love.graphics.setColor(0,0,0)
			love.graphics.print("pontuação:" .. soma,400,0,0,2)
			if jogador.x<-100 then
				telas_jogo=3
				love.audio.play(perca)
			end

	end

	if telas_jogo==3 then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(perdeu, 0, 0)
		--------
		love.graphics.print(soma,480,250,0,3)
		
		
		-----
		love.audio.stop(bgm)
		-----
		-----
		if love.keyboard.isDown('escape') then
	    	love.event.push('quit')
	    end
	    
	    if love.keyboard.isDown('r') then
	    	telas_jogo=1
	    	soma=0
	    end



	    -----

	end
end

