//
//  VertexBufferObjectManager.mm
//  RaceGame
//
//  Created by UQTimes on 12/09/12.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#include "VertexBufferObjectManager.h"

void VertexBufferObjectManager::alloc(int size)
{
    glGenBuffers(1, &vbo);
    
    vertices = new GLfloat[3 * size * 3];
    texCoords = new GLfloat[3 * size * 3];
    
    vCount = sizeof(GLfloat) * 3 * size * 3;
    tCount = sizeof(GLfloat) * 2 * size * 3;
    pCount = size;
}

void VertexBufferObjectManager::dealloc()
{
    glDeleteBuffers(1, &vbo);
    delete vertices;
    delete vertices;
}

void VertexBufferObjectManager::bufferData()
{
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    glBufferData(GL_ARRAY_BUFFER, vCount + tCount, 0, GL_STATIC_DRAW);
    glBufferSubData(GL_ARRAY_BUFFER, 0, vCount, vertices);
    glBufferSubData(GL_ARRAY_BUFFER, vCount, tCount, texCoords);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void VertexBufferObjectManager::draw()
{
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, 0, 0);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    glTexCoordPointer(2, GL_FLOAT, 0, (GLfloat *)vCount);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glDrawArrays(GL_TRIANGLES, 0, pCount * 3);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisable(GL_TEXTURE_2D);
}

void VertexBufferObjectManager::loadFromFile(NSString *filePath)
{
    NSError *error = nil;
    
    NSString *file = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSArray *fileLines = [file componentsSeparatedByString:@"\n"];
    
    NSMutableArray *vertexLines = [[NSMutableArray alloc] initWithCapacity:[fileLines count]];
    for (NSString *line in fileLines) {
        if ([line length] > 0 && [[line substringToIndex:2] compare:@"//"] != NSOrderedSame) {
            [vertexLines addObject:line];
        }
    }
    
    int polygonsCount = [vertexLines count] / 3;
    
    this->alloc(polygonsCount);
    
    int vertexId = 0, texCoordId = 0;
	for (NSString* lineStr in vertexLines){
		NSArray* lineElements = [lineStr componentsSeparatedByString:@","];
		vertices[vertexId++] = [[lineElements objectAtIndex:0] floatValue];
		vertices[vertexId++] = [[lineElements objectAtIndex:1] floatValue];
		vertices[vertexId++] = [[lineElements objectAtIndex:2] floatValue];
		texCoords[texCoordId++] = [[lineElements objectAtIndex:3] floatValue];
		texCoords[texCoordId++] = [[lineElements objectAtIndex:4] floatValue];
	}

    this->bufferData();
    
    [vertexLines release];
}
