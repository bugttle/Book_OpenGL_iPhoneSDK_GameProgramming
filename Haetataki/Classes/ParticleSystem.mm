//
//  ParticleSystem.mm
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "ParticleSystem.h"

//コンストラクタ
//ここで、パーティクルの最大数および寿命を設定します
//最大数が多いほど、寿命は長いほど全体の負荷が大きくなります。
ParticleSystem::ParticleSystem(int capacity, int particleLifeSpan){
	this->capacity = capacity;
	
	//particle配列を動的に用意します
	particle = new Particle*[capacity];
	
	//パーティクル管理用の配列を生成
	for(int i=0;i<capacity;i++){
		particle[i] = new Particle();
		particle[i]->lifeSpan = particleLifeSpan;
	}
}

//デコンストラクタ
//ここで使用したパーティクルを破棄します
ParticleSystem::~ParticleSystem(){
	//パーティクルを削除
	for(int i=0;i<capacity; i++){
		delete particle[i];
	}
	delete particle;
}

//指定した位置に新しいパーティクルを出現させます
void ParticleSystem::add(float x, float y, float size, float moveX, float moveY){
	for(int i=0;i<capacity;i++){
		//状態が非アクティブ(使用中ではない)のパーティクルを探します
		if(particle[i]->activeFlag == false){
			particle[i]->activeFlag = true;	//アクティブ(使用中)にします
			particle[i]->x = x;
			particle[i]->y = y;
			particle[i]->size = size;
			particle[i]->moveX = moveX;
			particle[i]->moveY = moveY;
			particle[i]->frameNumber = 0;
			break;
		}
	}
}

//パーティクル全体を描画します
void ParticleSystem::draw(GLuint texture){
	
	//頂点の配列
	//一つのパーティクルあたり6頂点 x 2要素(x,y) x 最大のパーティクル数
	GLfloat vertices[6 * 2 * capacity];

	//色の配列			
	//一つのパーティクルあたり6頂点 x 4要素(r,g,b,a) x 最大のパーティクル数
	GLubyte colors[6 * 4 * capacity];	

	//テクスチャマッピングの配列		
	//一つのパーティクルあたり6頂点 x 2要素(x,y) x 最大のパーティクル数
	GLfloat texCoords[6 * 2 * capacity];
	
	//アクティブなパーティクルのカウント
	int vertexIndex = 0;
	int colorIndex = 0;
	int texCoordIndex = 0;
	
	int activeParticleCount = 0;
	//一つずつパーティクルを見ていきます
	for(int i=0;i<capacity;i++){
		//状態がアクティブ(使用中)のパーティクルのみ描画します
		if(particle[i]->activeFlag == true){
			
			//頂点座標を追加します
			float centerX = particle[i]->x;
			float centerY = particle[i]->y;
			float size = particle[i]->size;
			float vLeft = -0.5f*size + centerX;
			float vRight = 0.5f*size + centerX;
			float vTop = 0.5f*size + centerY;
			float vBottom = -0.5f*size + centerY;
			
			//ポリゴン1
			vertices[vertexIndex++] = vLeft;	vertices[vertexIndex++] = vTop;		//左上
			vertices[vertexIndex++] = vRight;	vertices[vertexIndex++] = vTop;		//右上
			vertices[vertexIndex++] = vLeft;	vertices[vertexIndex++] = vBottom;	//左下
			
			//ポリゴン2
			vertices[vertexIndex++] = vRight;	vertices[vertexIndex++] = vTop;		//右上
			vertices[vertexIndex++] = vLeft;	vertices[vertexIndex++] = vBottom;	//左下
			vertices[vertexIndex++] = vRight;	vertices[vertexIndex++] = vBottom;	//右下
			
			//色
			float lifePercentage = (float)(particle[i]->frameNumber) / (float)(particle[i]->lifeSpan);
			int alpha;
			if(lifePercentage <= 0.5f){	//まだ寿命が半分以上のこっている場合
				alpha = (int)round(lifePercentage * 2.0f * 255.0f);
			}else{
				alpha = 255 - (int)round(lifePercentage * 2.0f * 255.0f);
			}
			
			colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = alpha;	
			colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = alpha;	
			colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = alpha;	
			colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = alpha;	
			colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = alpha;	
			colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = 255;	colors[colorIndex++] = alpha;	
			
			//マッピング座標
			//ポリゴン1
			texCoords[texCoordIndex++] = 0.0f;	texCoords[texCoordIndex++] = 0.0f;	//左上
			texCoords[texCoordIndex++] = 1.0f;	texCoords[texCoordIndex++] = 0.0f;	//右上
			texCoords[texCoordIndex++] = 0.0f;	texCoords[texCoordIndex++] = 1.0f;	//左下
			//ポリゴン2
			texCoords[texCoordIndex++] = 1.0f;	texCoords[texCoordIndex++] = 0.0f;	//右上
			texCoords[texCoordIndex++] = 0.0f;	texCoords[texCoordIndex++] = 1.0f;	//左下
			texCoords[texCoordIndex++] = 1.0f;	texCoords[texCoordIndex++] = 1.0f;	//右下
			
			//アクティブパーティクルの数を数えます
			activeParticleCount++;
		}
	}
	
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, texture);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    glEnableClientState(GL_COLOR_ARRAY);
    
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glDrawArrays(GL_TRIANGLES, 0, activeParticleCount * 6);
	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
}

//一つ一つのパーティクルを更新します
void ParticleSystem::update(){
	for(int i=0;i<capacity;i++){
		//状態がアクティブ(使用中)のパーティクルのみ処理します
		if(particle[i]->activeFlag == true){
			particle[i]->update();
		}
	}
}
