import numpy as np
import matplotlib.pyplot as plt
import sys


def mesh_download(name):
    with open(name) as file:
        allfile = file.readlines()

    # Точки собираем
    for i, val in enumerate(allfile):
        if val == '*NODE\n':
            answer = allfile[i:]
            for i, val in enumerate(answer):
                if val =='$\n':
                    answer = answer[:i]
                    break

    points = np.zeros((len(answer[2:]), 3))
    for i, elem in enumerate(answer[2:]):
        points[i] = [float(val) for val in elem.split(' ') if val != ''][:3]

    points = {int(points[i,0]): (points[i,1], points[i,2]) for i in range(len(points))}

    #  Треугольники собираем
    for i, val in enumerate(allfile):
        if val == '*ELEMENT_SHELL\n':
            answer = allfile[i:]
            for i, val in enumerate(answer):
                if val =='*END\n':
                    answer = answer[:i]
                    break

    triang = np.zeros((len(answer[1:]), 4))
    for i, elem in enumerate(answer[1:]):
        triang[i] = [i+1] + [val for val in elem.split(' ') if val != ''][2:5]
    triang = triang.astype('int')
    triang = {triang[i,0]: (triang[i,1], triang[i,2], triang[i,3]) for i in range(len(triang))}
    
    return points, triang

def plot_triang(i, color='green'):
    t1, t2, t3 = triang[i]
    x , y = list(zip(points[t1],points[t2]))
    plt.plot(x,y, color)
    x , y = list(zip(points[t2],points[t3]))
    plt.plot(x,y, color)
    x , y = list(zip(points[t3],points[t1]))
    plt.plot(x,y, color)


if __name__ == '__main__':
    for argv_i in range(1, len(sys.argv)):
        points, triang = mesh_download(sys.argv[argv_i])
        fig = plt.figure(figsize=(5.5, 5.5))    
        coord = [i[1] for i in points.items()]
        ind = [i[0] for i in points.items()]
        x = [i[0] for i in coord]
        y = [i[1] for i in coord]
        plt.scatter(x, y)
        for i in triang.keys():
            plot_triang(i, 'green')
        fig.savefig(sys.argv[argv_i] + '.jpg')
        

