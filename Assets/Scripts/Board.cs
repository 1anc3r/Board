using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Board : MonoBehaviour
{
    public string type;
    private GameObject board;
    private Vector3[] matrix;
    private const int cubeCount = 18;
    private const int lineCount = cubeCount + 1;
    private const float boardWidth = 5.76f;
    private const float cubeHeight = 0.26f;
    private const float cubeWidth = boardWidth / cubeCount;
    private const float lineWidth = 0.003f;

    void Start()
    {
        initBoard();
    }

    void Update()
    {

    }

    public void initBoard()
    {
        // 建立网格坐标点阵列
        matrix = new Vector3[lineCount * lineCount];
        for (int y = 0; y < lineCount; ++y)
        {
            for (int x = 0; x < lineCount; ++x)
            {
                matrix[y * lineCount + x] = new Vector3(((float)x) * cubeWidth, 0, ((float)y) * cubeWidth);
            }
        }

        // 建立[vert][Normals][UVs]
        Vector3[] vertices = new Vector3[lineCount * lineCount];
        Vector3[] norms = new Vector3[lineCount * lineCount];
        Vector2[] UVs = new Vector2[lineCount * lineCount];

        for (int y = 0; y < lineCount; ++y)
        {
            for (int x = 0; x < lineCount; ++x)
            {
                vertices[y * lineCount + x] = matrix[y * lineCount + x];
                norms[y * lineCount + x] = Vector3.up;
                UVs[y * lineCount + x] = new Vector2((1 / (float)cubeCount) * x, (1 / (float)cubeCount) * y);
            }
        }

        // 建立[Triangle]
        int[] triangles = new int[cubeCount * cubeCount * 6];
        int ind = 0;
        for (int y = 0; y < cubeCount; ++y)
        {
            for (int x = 0; x < cubeCount; ++x)
            {
                triangles[ind++] = y * lineCount + x;
                triangles[ind++] = (y + 1) * lineCount + (x + 1);
                triangles[ind++] = y * lineCount + (x + 1);
                triangles[ind++] = y * lineCount + x;
                triangles[ind++] = (y + 1) * lineCount + x;
                triangles[ind++] = (y + 1) * lineCount + (x + 1);
            }
        }

        // 建立新的MeshRenderer并设定好材质
        board = new GameObject("Grid Line");
        board.transform.position = new Vector3(-cubeWidth * cubeCount / 2, cubeHeight, -cubeWidth * cubeCount / 2);
        MeshRenderer mr = board.AddComponent(typeof(MeshRenderer)) as MeshRenderer;
        mr.material = new Material(Shader.Find("Custom/" + type));
        mr.material.SetFloat("_lineWidth", lineWidth);
        mr.material.SetFloat("_gridSpace", 2f / cubeCount);
        mr.material.SetFloat("_gridCount", cubeCount);
        MeshFilter mf = board.AddComponent(typeof(MeshFilter)) as MeshFilter;
        Mesh mesh = new Mesh();
        mesh.vertices = vertices;
        mesh.normals = norms;
        mesh.triangles = triangles;
        mesh.uv = UVs;
        Color[] colors = new Color[matrix.Length];
        mesh.colors = colors;
        mf.mesh = mesh;
        board.transform.parent = this.transform;
    }
}
