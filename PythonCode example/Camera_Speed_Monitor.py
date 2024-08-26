import bpy
import mathutils
import os

# 获取当前场景和相机对象
scene = bpy.context.scene
camera = scene.camera

# 用于存储相机的前一帧位置和速度信息
previous_location = None
speeds = []

# 设置输出文件路径
output_file = os.path.join(bpy.path.abspath("//"), "camera_speeds.txt")

def calculate_speed(current_location, previous_location):
    # 计算当前位置与前一帧位置之间的距离
    distance = (current_location - previous_location).length
    # 速度单位：米/帧
    return distance

def frame_change_handler(scene):
    global previous_location, speeds
    
    # 获取当前相机的位置
    current_location = camera.location.copy()
    
    if previous_location is not None:
        # 计算速度
        speed = calculate_speed(current_location, previous_location)
        speeds.append(speed)
        print(f"Frame: {scene.frame_current}, Speed: {speed:.4f} meters/frame")
        
        # 将速度信息写入文件
        with open(output_file, 'a') as f:
            f.write(f"Frame: {scene.frame_current}, Speed: {speed:.4f} meters/frame\n")
    
    # 更新前一帧位置
    previous_location = current_location

def calculate_average_speed():
    if speeds:
        average_speed = sum(speeds) / len(speeds)
        print(f"Average Speed: {average_speed:.4f} meters/frame")
        
        # 将平均速度写入文件
        with open(output_file, 'a') as f:
            f.write(f"\nAverage Speed: {average_speed:.4f} meters/frame\n")

# 注册帧变化处理程序
bpy.app.handlers.frame_change_pre.append(frame_change_handler)

# 在动画播放结束时计算平均速度
def playback_finished_handler(scene):
    calculate_average_speed()

# 注册动画播放结束处理程序
bpy.app.handlers.frame_change_post.append(playback_finished_handler)

# 在渲染完成后计算平均速度
def render_complete_handler(scene):
    calculate_average_speed()

# 注册渲染完成处理程序
bpy.app.handlers.render_complete.append(render_complete_handler)
