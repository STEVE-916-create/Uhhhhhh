# credits to 2024 STEVE

import io, os, struct, warnings, base64, re, math, struct
import xml.etree.ElementTree as ET

def _parsecall(f, x):
	try: return f(x)
	except ValueError: return None
def parseInt(x):
	return _parsecall(int, x)
def parseFloat(x):
	return _parsecall(float, x)
def read_lz4header(b):
	compressed_size = struct.unpack("<I", b.read(4))[0]
	decompressed_size = struct.unpack("<I", b.read(4))[0]
	b.seek(4, 1)
	return compressed_size, decompressed_size
def read_lz4(b):
	compressed_size, decompressed_size = read_lz4header(b)
	if compressed_size == 0:
		return b.read(decompressed_size)
	databuffer = [0] * decompressed_size
	index = 0
	while index < decompressed_size:
		token = b.read(1)[0]
		literal_length = token >> 4
		if literal_length == 15:
			while True:
				v = b.read(1)[0]
				if v == 255:
					literal_length += 255
				else:
					literal_length += v
					break
		for _ in range(literal_length):
			databuffer[index] = b.read(1)[0]
			index += 1
		if index < decompressed_size:
			match_offset = index - struct.unpack("<H", b.read(2))[0]
			match_length = (token & 0xF) + 4
			if match_length == 19:
				while True:
					v = b.read(1)[0]
					if v == 255:
						match_length += 255
					else:
						match_length += v
						break
			for _ in range(match_length):
				databuffer[index] = databuffer[match_offset]
				index += 1
				match_offset += 1
	return bytes(databuffer)
def read_RBXInterleavedUint16(b, count):
	data = b.read(count * 2)
	result = [0] * count
	for i in range(count):
		result[i] = (data[i + (count * 0)] << 8) | (data[i + (count * 1)] << 0)
	return result
def read_RBXInterleavedUint32(b, count):
	data = b.read(count * 4)
	result = [0] * count
	for i in range(count):
		result[i] = (data[i + (count * 0)] << 24) | (data[i + (count * 1)] << 16) | (data[i + (count * 2)] << 8) | (data[i + (count * 3)] << 0)
	return result
def read_RBXInterleavedUint64(b, count):
	data = b.read(count * 8)
	result = [0] * count
	for i in range(count):
		result[i] = (data[i + (count * 0)] << 56) | (data[i + (count * 1)] << 48) | (data[i + (count * 2)] << 40) | (data[i + (count * 3)] << 32) | (data[i + (count * 4)] << 24) | (data[i + (count * 5)] << 16) | (data[i + (count * 6)] << 8) | (data[i + (count * 7)] << 0)
	return result
def read_RBXInterleavedInt16(b, count):
	data = read_RBXInterleavedUint16(b, count)
	result = [0] * count
	for i in range(count):
		result[i] = data[i] // 2
		if data[i] % 2 > 0:
			result[i] = -(data[i] + 1) // 2
	return result
def read_RBXInterleavedInt32(b, count):
	data = read_RBXInterleavedUint32(b, count)
	result = [0] * count
	for i in range(count):
		result[i] = data[i] // 2
		if data[i] % 2 > 0:
			result[i] = -(data[i] + 1) // 2
	return result
def read_RBXInterleavedInt64(b, count):
	data = read_RBXInterleavedUint64(b, count)
	result = [0] * count
	for i in range(count):
		result[i] = data[i] // 2
		if data[i] % 2 > 0:
			result[i] = -(data[i] + 1) // 2
	return result
def read_RBXInterleavedFloat(b, count):
	data = read_RBXInterleavedUint32(b, count)
	result = [0.0] * count
	for i in range(count):
		x = data[i]
		bs = struct.pack("<I", ((x & 1) << 31) | (x >> 1))
		result[i] = struct.unpack("<f", bs)[0]
	return result

# mathematically accurate power function
def _mathematically_accurate_power_function(x: float, y: float) -> float:
	if y == 0:
		return 1.0
	elif y < 0:
		x = math.pow(x, -y)
		if x != 0:
			return 1.0 / x
		else:
			return 0.0 # undefined case
	else:
		return math.pow(x, y)
def _better_quaternion_smooth_lerp_formula_great_for_animations_and_stuff(q0: list[float], q1: list[float], alpha: float) -> list[float]:
	assert len(q0) == len(q1), "Vector number of components not equal"
	# better smooth lerp formula
	# compute dot product
	dot = q0[0]*q1[0] + q0[1]*q1[1] + q0[2]*q1[2] + q0[3]*q1[3]
	if dot < 0:
		q1 = [-x for x in q1]
		dot = -dot
	# if quats are nearly identical, do normalized lerp
	if dot > 0.9995:
		res = [q0[i] + alpha * (q1[i] - q0[i]) for i in range(4)]
		norm = math.sqrt(sum(x*x for x in res))
		return [x/norm for x in res]
	# else, we can actually do the smooth lerp
	theta_0 = math.acos(dot)
	sin_theta_0 = math.sin(theta_0)
	s0 = math.sin((1-alpha)*theta_0) / sin_theta_0
	s1 = math.sin(alpha*theta_0) / sin_theta_0
	res = [s0*q0[i] + s1*q1[i] for i in range(4)]
	norm = math.sqrt(sum(x*x for x in res))
	return [x/norm for x in res]

class Vector3:
	"""
	Vector with 3 components. Technological!
	"""
	def __init__(self, x=0.0, y=0.0, z=0.0):
		self.x, self.y, self.z = x, y, z
	def __repr__(self):
		return "Vector3(" + str(self.x) + ", " + str(self.y) + ", " + str(self.z) + ")"
	def __hash__(self):
		return hash("<Vector3>=)" + struct.pack("<fff", self.x, self.y, self.z).hex())
	@property
	def magnitude(self):
		return math.sqrt((self.x ** 2) + (self.y ** 2) + (self.z ** 2))
	@property
	def unit(self):
		mag = self.magnitude
		if mag == 0:
			return Vector3()
		return Vector3(self.x / mag, self.y / mag, self.z / mag)
	def dot(self, other):
		return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
	def cross(self, other):
		return Vector3(
			self.y * other.z - self.z * other.y,
			self.z * other.x - self.x * other.z,
			self.x * other.y - self.y * other.x
		)
	def rotate(self, other):
		ro = self.dupe()
		ro.x, ro.y = math.cos(other.z) * ro.x - math.sin(other.z) * ro.y, math.sin(other.z) * ro.x + math.cos(other.z) * ro.y
		ro.y, ro.z = math.cos(other.x) * ro.y - math.sin(other.x) * ro.z, math.sin(other.x) * ro.y + math.cos(other.x) * ro.z
		ro.z, ro.x = math.cos(other.y) * ro.z - math.sin(other.y) * ro.x, math.sin(other.y) * ro.z + math.cos(other.y) * ro.x
		return ro
	def inv_rotate(self, other):
		ro = self.dupe()
		ro.z, ro.x = math.cos(-other.y) * ro.z - math.sin(-other.y) * ro.x, math.sin(-other.y) * ro.z + math.cos(-other.y) * ro.x
		ro.y, ro.z = math.cos(-other.x) * ro.y - math.sin(-other.x) * ro.z, math.sin(-other.x) * ro.y + math.cos(-other.x) * ro.z
		ro.x, ro.y = math.cos(-other.z) * ro.x - math.sin(-other.z) * ro.y, math.sin(-other.z) * ro.x + math.cos(-other.z) * ro.y
		return ro
	def lerp(self, other, alpha):
		return self + ((other - self) * alpha)
	def dupe(self):
		return Vector3(self.x, self.y, self.z)
	def __add__(self, other):
		return Vector3(
			self.x + other.x,
			self.y + other.y,
			self.z + other.z
		)
	def __sub__(self, other):
		return Vector3(
			self.x - other.x,
			self.y - other.y,
			self.z - other.z
		)
	def __mul__(self, other):
		if type(other) != Vector3:
			return self * Vector3(other, other, other)
		return Vector3(
			self.x * other.x,
			self.y * other.y,
			self.z * other.z
		)
	def __truediv__(self, other):
		if type(other) != Vector3:
			return self / Vector3(other, other, other)
		return Vector3(
			self.x / other.x,
			self.y / other.y,
			self.z / other.z
		)
	def __neg__(self):
		return Vector3(-self.x, -self.y, -self.z)
	def __eq__(self, other):
		return self.x == other.x and self.y == other.y and self.z == other.z
class Vector2:
	"""
	Vector with 2 components. So retro and oldschoolz !
	"""
	def __init__(self, x=0.0, y=0.0):
		self.x, self.y = x, y
	def __repr__(self):
		return "Vector2(" + str(self.x) + ", " + str(self.y) + ")"
	def __hash__(self):
		return hash("<Vector2>=)" + struct.pack("<ff", self.x, self.y).hex())
	@property
	def magnitude(self):
		return math.sqrt((self.x ** 2) + (self.y ** 2))
	@property
	def unit(self):
		mag = self.magnitude
		if mag == 0:
			return Vector2()
		return Vector2(self.x / mag, self.y / mag)
	def rotate(self, radians):
		ro = self.dupe()
		ro.x, ro.y = math.cos(-radians) * ro.x - math.sin(-radians) * ro.y, math.sin(-radians) * ro.x + math.cos(-radians) * ro.y
		return ro
	def lerp(self, other, alpha):
		return self + ((other - self) * alpha)
	def dupe(self):
		return Vector2(self.x, self.y)
	def __add__(self, other):
		return Vector2(
			self.x + other.x,
			self.y + other.y
		)
	def __sub__(self, other):
		return Vector2(
			self.x - other.x,
			self.y - other.y
		)
	def __mul__(self, other):
		if type(other) != Vector2:
			return self * Vector2(other, other)
		return Vector2(
			self.x * other.x,
			self.y * other.y
		)
	def __truediv__(self, other):
		if type(other) != Vector2:
			return self / Vector2(other, other)
		return Vector2(
			self.x / other.x,
			self.y / other.y
		)
	def __neg__(self):
		return Vector2(-self.x, -self.y)
	def __eq__(self, other):
		return self.x == other.x and self.y == other.y
class Matrix4:
	"""
	A 4x4 Matrix with 16 components! PEAK COMPLEXITY!!!
	"""
	def __init__(self):
		self.m = [
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		]
	@staticmethod
	def proj_perspective(fov, aspect, near, far):
		mat = Matrix4()
		fov = fov * math.pi / 180
		f = 1 / math.tan(fov / 2)
		mat.m = [
			f / aspect, 0, 0, 0,
			0, f, 0, 0,
			0, 0, -1, -1,
			0, 0, -2 * near, 0
		]
		if far != math.inf:
			nf = 1 / (near - far)
			mat.m[10] = (far + near) * nf
			mat.m[14] = 2 * far * near * nf
		return mat
	@staticmethod
	def proj_orthogonal(horiz, verti, near, far):
		mat = Matrix4()
		mat.m = [
			2 / horiz, 0, 0, 0,
			0, 2 / verti, 0, 0,
			0, 0, -2 / (far - near), 0,
			0, 0, 0, 1
		]
		return mat
	def copy(self, src):
		self.m = src.m
	def clone(self):
		cl = Matrix4()
		cl.copy(self)
		return cl
	def transpose(self):
		trans = Matrix4()
		for y in range(4):
			for x in range(4):
				trans.m[x + (y * 4)] = self.m[y + (x * 4)]
		return trans
	def inverse(self):
		inv = Matrix4()
		a00, a01, a02, a03 = self.m[0], self.m[1], self.m[2], self.m[3]
		a10, a11, a12, a13 = self.m[4], self.m[5], self.m[6], self.m[7]
		a20, a21, a22, a23 = self.m[8], self.m[9], self.m[10], self.m[11]
		a30, a31, a32, a33 = self.m[12], self.m[13], self.m[14], self.m[15]
		b00 = a00 * a11 - a01 * a10
		b01 = a00 * a12 - a02 * a10
		b02 = a00 * a13 - a03 * a10
		b03 = a01 * a12 - a02 * a11
		b04 = a01 * a13 - a03 * a11
		b05 = a02 * a13 - a03 * a12
		b06 = a20 * a31 - a21 * a30
		b07 = a20 * a32 - a22 * a30
		b08 = a20 * a33 - a23 * a30
		b09 = a21 * a32 - a22 * a31
		b10 = a21 * a33 - a23 * a31
		b11 = a22 * a33 - a23 * a32
		det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06
		if det != 0:
			det = 1.0 / det
			inv.m[0] = (a11 * b11 - a12 * b10 + a13 * b09) * det
			inv.m[1] = (a02 * b10 - a01 * b11 - a03 * b09) * det
			inv.m[2] = (a31 * b05 - a32 * b04 + a33 * b03) * det
			inv.m[3] = (a22 * b04 - a21 * b05 - a23 * b03) * det
			inv.m[4] = (a12 * b08 - a10 * b11 - a13 * b07) * det
			inv.m[5] = (a00 * b11 - a02 * b08 + a03 * b07) * det
			inv.m[6] = (a32 * b02 - a30 * b05 - a33 * b01) * det
			inv.m[7] = (a20 * b05 - a22 * b02 + a23 * b01) * det
			inv.m[8] = (a10 * b10 - a11 * b08 + a13 * b06) * det
			inv.m[9] = (a01 * b08 - a00 * b10 - a03 * b06) * det
			inv.m[10] = (a30 * b04 - a31 * b02 + a33 * b00) * det
			inv.m[11] = (a21 * b02 - a20 * b04 - a23 * b00) * det
			inv.m[12] = (a11 * b07 - a10 * b09 - a12 * b06) * det
			inv.m[13] = (a00 * b09 - a01 * b07 + a02 * b06) * det
			inv.m[14] = (a31 * b01 - a30 * b03 - a32 * b00) * det
			inv.m[15] = (a20 * b03 - a21 * b01 + a22 * b00) * det
		return inv
	def translate(self, vec):
		trans = self.clone()
		trans.m[12] += (trans.m[0] * vec.x) + (trans.m[4] * vec.y) + (trans.m[8] * vec.z)
		trans.m[13] += (trans.m[1] * vec.x) + (trans.m[5] * vec.y) + (trans.m[9] * vec.z)
		trans.m[14] += (trans.m[2] * vec.x) + (trans.m[6] * vec.y) + (trans.m[10] * vec.z)
		return trans
	def scale(self, vec):
		scl = self.clone()
		scl.m[0] *= vec.x
		scl.m[1] *= vec.x
		scl.m[2] *= vec.x
		scl.m[3] *= vec.x
		scl.m[4] *= vec.y
		scl.m[5] *= vec.y
		scl.m[6] *= vec.y
		scl.m[7] *= vec.y
		scl.m[8] *= vec.z
		scl.m[9] *= vec.z
		scl.m[10] *= vec.z
		scl.m[11] *= vec.z
		return scl
	def _rotate(self, rad, x, y, z):
		s = math.sin(rad)
		c = math.cos(rad)
		t = 1 - c
		a00 = self.m[0]
		a01 = self.m[1]
		a02 = self.m[2]
		a03 = self.m[3]
		a10 = self.m[4]
		a11 = self.m[5]
		a12 = self.m[6]
		a13 = self.m[7]
		a20 = self.m[8]
		a21 = self.m[9]
		a22 = self.m[10]
		a23 = self.m[11]
		b00 = x * x * t + c
		b01 = y * x * t + z * s
		b02 = z * x * t - y * s
		b10 = x * y * t - z * s
		b11 = y * y * t + c
		b12 = z * y * t + x * s
		b20 = x * z * t + y * s
		b21 = y * z * t - x * s
		b22 = z * z * t + c
		self.m[0] = a00 * b00 + a10 * b01 + a20 * b02
		self.m[1] = a01 * b00 + a11 * b01 + a21 * b02
		self.m[2] = a02 * b00 + a12 * b01 + a22 * b02
		self.m[3] = a03 * b00 + a13 * b01 + a23 * b02
		self.m[4] = a00 * b10 + a10 * b11 + a20 * b12
		self.m[5] = a01 * b10 + a11 * b11 + a21 * b12
		self.m[6] = a02 * b10 + a12 * b11 + a22 * b12
		self.m[7] = a03 * b10 + a13 * b11 + a23 * b12
		self.m[8] = a00 * b20 + a10 * b21 + a20 * b22
		self.m[9] = a01 * b20 + a11 * b21 + a21 * b22
		self.m[10] = a02 * b20 + a12 * b21 + a22 * b22
		self.m[11] = a03 * b20 + a13 * b21 + a23 * b22
	def rotate(self, vec):
		rot = self.clone()
		rot._rotate(vec.z, 0, 0, 1)
		rot._rotate(vec.y, 0, 1, 0)
		rot._rotate(vec.x, 1, 0, 0)
		return rot
	def strip_position(self):
		strp = self.clone()
		strp.m[12] = 0
		strp.m[13] = 0
		strp.m[14] = 0
		strp.m[15] = 1
		return strp
	def strip_rotation(self):
		strp = Matrix4()
		strp.m[12] = self.m[12]
		strp.m[13] = self.m[13]
		strp.m[14] = self.m[14]
		strp.m[15] = 1
		return strp
	def __mul__(self, other):
		r0 = self.m[0]*other.m[0] + self.m[1]*other.m[4] + self.m[2]*other.m[8]
		r1 = self.m[0]*other.m[1] + self.m[1]*other.m[5] + self.m[2]*other.m[9]
		r2 = self.m[0]*other.m[2] + self.m[1]*other.m[6] + self.m[2]*other.m[10]
		r3 = self.m[0]*other.m[3] + self.m[1]*other.m[7] + self.m[2]*other.m[11]
		r4 = self.m[4]*other.m[0] + self.m[5]*other.m[4] + self.m[6]*other.m[8]
		r5 = self.m[4]*other.m[1] + self.m[5]*other.m[5] + self.m[6]*other.m[9]
		r6 = self.m[4]*other.m[2] + self.m[5]*other.m[6] + self.m[6]*other.m[10]
		r7 = self.m[4]*other.m[3] + self.m[5]*other.m[7] + self.m[6]*other.m[11]
		r8  = self.m[8]*other.m[0] + self.m[9]*other.m[4] + self.m[10]*other.m[8]
		r9  = self.m[8]*other.m[1] + self.m[9]*other.m[5] + self.m[10]*other.m[9]
		r10 = self.m[8]*other.m[2] + self.m[9]*other.m[6] + self.m[10]*other.m[10]
		r11 = self.m[8]*other.m[3] + self.m[9]*other.m[7] + self.m[10]*other.m[11]
		r12 = self.m[12]*other.m[0] + self.m[13]*other.m[4] + self.m[14]*other.m[8]  + other.m[12]
		r13 = self.m[12]*other.m[1] + self.m[13]*other.m[5] + self.m[14]*other.m[9]  + other.m[13]
		r14 = self.m[12]*other.m[2] + self.m[13]*other.m[6] + self.m[14]*other.m[10] + other.m[14]
		r15 = self.m[12]*other.m[3] + self.m[13]*other.m[7] + self.m[14]*other.m[11] + other.m[15]
		result = Matrix4()
		result.m = [r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15]
		return result

class CFrame:
	"""
	Simplified Matrix4 with no scaling and 12 components! Futuristic !!!
	"""
	def __init__(self, *args):
		self.r00, self.r10, self.r20 = 1, 0, 0
		self.r01, self.r11, self.r21 = 0, 1, 0
		self.r02, self.r12, self.r22 = 0, 0, 1
		self.x, self.y, self.z = 0, 0, 0
		if len(args) == 1:
			p = args[0]
			self.x, self.y, self.z = p.x, p.y, p.z
		if len(args) == 2:
			cf = CFrame.look_at(args[0], args[1])
			self.r00, self.r10, self.r20 = cf.r00, cf.r10, cf.r20
			self.r01, self.r11, self.r21 = cf.r01, cf.r11, cf.r21
			self.r02, self.r12, self.r22 = cf.r02, cf.r12, cf.r22
			self.x, self.y, self.z = cf.x, cf.y, cf.z
		if len(args) == 3:
			self.x, self.y, self.z = tuple(args)
		if len(args) == 12:
			self.x, self.y, self.z, self.r00, self.r01, self.r02, self.r10, self.r11, self.r12, self.r20, self.r21, self.r22 = tuple(args)
	@staticmethod
	def look_along(pos, along, up=Vector3(0, 1, 0)):
		zaxis = -along.unit
		xaxis = up.cross(zaxis)
		yaxis = zaxis.cross(xaxis).unit
		if xaxis.magnitude == 0:
			xaxis = Vector3(0, 0, zaxis.y).unit
			yaxis = Vector3(zaxis.y, 0, 0).unit
			zaxis = Vector3(0, -1, 0) if zaxis.y < 0 else Vector3(0, 1, 0)
		xaxis = xaxis.unit
		return CFrame(
			pos.x, pos.y, pos.z,
			xaxis.x, yaxis.x, zaxis.x,
			xaxis.y, yaxis.y, zaxis.y,
			xaxis.z, yaxis.z, zaxis.z
		)
	@staticmethod
	def look_at(pos, at, up=Vector3(0, 1, 0)):
		return CFrame.look_along(pos, at - pos, up)
	@staticmethod
	def from_quaternion(q):
		x, y, z, w = tuple(q)
		x2 = x + x
		y2 = y + y
		z2 = z + z
		xx = x * x2
		yx = y * x2
		yy = y * y2
		zx = z * x2
		zy = z * y2
		zz = z * z2
		wx = w * x2
		wy = w * y2
		wz = w * z2
		r00 = 1 - yy - zz
		r10 = yx + wz
		r20 = zx - wy
		r01 = yx - wz
		r11 = 1 - xx - zz
		r21 = zy + wx
		r02 = zx + wy
		r12 = zy - wx
		r22 = 1 - xx - yy
		return CFrame(0, 0, 0, r00, r01, r02, r10, r11, r12, r20, r21, r22)
	@staticmethod
	def from_matrix4(mat):
		m = mat.m
		xaxis = Vector3(m[0], m[1], m[2]).unit
		yaxis = Vector3(m[4], m[5], m[6]).unit
		zaxis = Vector3(m[8], m[9], m[10]).unit
		pos = Vector3(m[12], m[13], m[14])
		return CFrame(
			pos.x, pos.y, pos.z,
			xaxis.x, xaxis.y, xaxis.z,
			xaxis.y, yaxis.y, yaxis.z,
			xaxis.z, zaxis.y, zaxis.z
		)
	@property
	def position(self):
		return Vector3(self.x, self.y, self.z)
	@property
	def rightVector(self):
		return Vector3(self.r00, self.r10, self.r20).unit
	@property
	def upVector(self):
		return Vector3(self.r01, self.r11, self.r21).unit
	@property
	def lookVector(self):
		return -Vector3(self.r02, self.r12, self.r22).unit
	@property
	def rotation(self):
		return CFrame.from_quaternion(self.to_quaternion())
	def to_quaternion(self):
		trace = self.r00 + self.r11 + self.r22
		if trace > 0:
			S = math.sqrt(1 + trace) * 2
			return [
				(self.r21 - self.r12) / S,
				(self.r02 - self.r20) / S,
				(self.r10 - self.r01) / S,
				S / 4
			]
		elif self.r00 > self.r11 and self.r00 > self.r22:
			S = math.sqrt(1 + self.r00 - self.r11 - self.r22) * 2
			return [
				S / 4,
				(self.r01 + self.r10) / S,
				(self.r02 + self.r20) / S,
				(self.r21 - self.r12) / S
			]
		elif self.r11 > self.r22:
			S = math.sqrt(1 + self.r11 - self.r00 - self.r22) * 2
			return [
				(self.r10 + self.r01) / S,
				S / 4,
				(self.r21 + self.r12) / S,
				(self.r02 - self.r20) / S
			]
		else:
			S = math.sqrt(1 + self.r22 - self.r00 - self.r11) * 2
			return [
				(self.r02 + self.r20) / S,
				(self.r21 + self.r12) / S,
				S / 4,
				(self.r10 - self.r01) / S
			]
	def to_matrix4(self):
		out = Matrix4()
		out.m = [
			self.r00, self.r10, self.r20, 0, 
			self.r01, self.r11, self.r21, 0, 
			self.r02, self.r12, self.r22, 0, 
			self.x, self.y, self.z, 1
		]
		return out
	def get_components(self):
		return self.x, self.y, self.z, self.r00, self.r01, self.r02, self.r10, self.r11, self.r12, self.r20, self.r21, self.r22
	def lerp(self, to, alpha):
		q0 = self.to_quaternion()
		q1 = to.to_quaternion()
		q2 = _better_quaternion_smooth_lerp_formula_great_for_animations_and_stuff(q0, q1, alpha)
		p0 = self.position
		p1 = to.position
		p2 = p0.lerp(p1, alpha)
		result = CFrame.from_quaternion(q2)
		result.x = p2.x
		result.y = p2.y
		result.z = p2.z
		return result
	def dupe(self):
		return CFrame(self.x, self.y, self.z, self.r00, self.r01, self.r02, self.r10, self.r11, self.r12, self.r20, self.r21, self.r22)
	def __add__(self, other):
		d = self.dupe()
		d.x += other.x
		d.y += other.y
		d.z += other.z
		return d
	def __sub__(self, other):
		return self + (-other) # redirect to __add__ with negation
	def __mul__(self, other):
		if type(other) is CFrame:
			# lets do sum simple matrix calculation
			# (its just cframe * cframe of how i understand it)
			# the position gets rotated from this cframe's perspective
			c1p = self.position + self.rotate_vector(other.position)
			# the directions from this cframe's perspective
			# will be based by the other cframe's directions
			c1x = self.rotate_vector(other.rightVector)
			c1y = self.rotate_vector(other.upVector)
			c1z = self.rotate_vector(-other.lookVector)
			# prub moment
			return CFrame(
				c1p.x, c1p.y, c1p.z,
				c1x.x, c1y.x, c1z.x,
				c1x.y, c1y.y, c1z.y,
				c1x.z, c1y.z, c1z.z
			)
		else:
			# docs say its equivalent to this
			return self.point_to_world_space(other)
	def rotate_vector(self, other) -> Vector3:
		return (self.rightVector * other.x) + (self.upVector * other.y) + (-self.lookVector * other.z)
	def point_to_world_space(self, other) -> Vector3:
		return self.position + self.rotate_vector(other)
	def point_to_object_space(self, other) -> Vector3:
		inv = self.inverse()
		return inv.point_to_world_space(other)
	def get_determinant(self):
		_, _, _, a00, a01, a02, a10, a11, a12, a20, a21, a22 = self.get_components()
		return a00*a11*a22 + a01*a12*a20 + a02*a10*a21 - a00*a12*a20 - a01*a10*a22 - a02*a11*a20
	def inverse__(self) -> "CFrame":
		inv = CFrame()
		det = self.get_determinant() # im guessing its always 1...or around 1
		if det == 0:
			return inv
		a03, a13, a23, a00, a01, a02, a10, a11, a12, a20, a21, a22 = self.get_components()
		inv.r00 = (a11 * a22 - a12 * a21) / det
		inv.r01 = (a02 * a21 - a01 * a22) / det
		inv.r02 = (a01 * a12 - a02 * a11) / det
		inv.r10 = (a12 * a20 - a10 * a22) / det
		inv.r11 = (a00 * a22 - a02 * a20) / det
		inv.r12 = (a02 * a10 - a00 * a12) / det
		inv.r20 = (a10 * a21 - a11 * a20) / det
		inv.r21 = (a01 * a20 - a00 * a21) / det
		inv.r22 = (a00 * a11 - a01 * a10) / det
		inv.x = (a01*a13*a22 + a02*a11*a23 + a03*a12*a21 - a01*a12*a23 - a02*a13*a21 - a03*a11*a22) / det
		inv.y = (a00*a12*a23 + a02*a13*a20 + a03*a10*a22 - a00*a13*a22 - a02*a10*a23 - a03*a12*a20) / det
		inv.z = (a00*a11*a22 + a01*a12*a20 + a02*a10*a21 - a00*a12*a21 - a01*a10*a22 - a02*a11*a20) / det
		return inv
	def inverse(self):
		# just lerp to the identity cframe twice bro its that easy
		inv = self.rotation.lerp(CFrame(), 2)
		pos = inv.rotate_vector(-self.position)
		inv.x = pos.x
		inv.y = pos.y
		inv.z = pos.z
		return inv
	def rotate(self, other):
		c1p = self.position
		c1x = self.rightVector.rotate(other)
		c1y = self.upVector.rotate(other)
		c1z = (-self.lookVector).rotate(other)
		return CFrame(
			c1p.x, c1p.y, c1p.z,
			c1x.x, c1y.x, c1z.x,
			c1x.y, c1y.y, c1z.y,
			c1x.z, c1y.z, c1z.z
		)

_Instance_nonproperties = [
	"__repr__",
	"GetChildren", "GetDescendants", "FindFirstChild", "FindFirstChildOfClass",
	"Name", "ClassName", "Parent"
]
class Instance:
	def __init__(self, class_name):
		object.__setattr__(self, "Name", class_name)
		object.__setattr__(self, "Parent", None)
		object.__setattr__(self, "ClassName", class_name)
		object.__setattr__(self, "properties", {})
		object.__setattr__(self, "children", [])
	def __getattribute__(self, k):
		if k in _Instance_nonproperties:
			return object.__getattribute__(self, k)
		else:
			return object.__getattribute__(self, "properties").get(k, None)
	def __setattr__(self, k, v):
		if k == "Name":
			object.__setattr__(self, "Name", v)
		elif k == "Parent":
			oldparent = object.__getattribute__(self, "Parent")
			object.__setattr__(self, "Parent", v)
			if oldparent is not None:
				object.__getattribute__(oldparent, "children").remove(self)
			if v is not None:
				object.__getattribute__(v, "children").append(self)
		elif k in _Instance_nonproperties:
			raise Exception("Cannot set read only property")
		else:
			object.__getattribute__(self, "properties")[k] = v
	def __repr__(self):
		name = self.Name
		classname = self.ClassName
		props = object.__getattribute__(self, "properties")
		child = object.__getattribute__(self, "children")
		return "Instance(" + repr(classname) + ") " + repr(name) + " " + repr(props) + " " + repr(child)
	def GetChildren(self):
		return object.__getattribute__(self, "children")
	def GetDescendants(self):
		childs = []
		children = object.__getattribute__(self, "children")
		for child in children:
			childs.append(child)
			childs += object.__getattribute__(child, "GetDescendants")()
		return childs
	def FindFirstChild(self, name):
		children = object.__getattribute__(self, "children")
		for child in children:
			if child.Name == name:
				return child
		return None
	def FindFirstChildOfClass(self, classname):
		children = object.__getattribute__(self, "children")
		for child in children:
			if child.ClassName == classname:
				return child
		return None

def _LerpV(v0, v1, alpha):
	assert len(v0) == len(v1), "Vector number of components not equal"
	v2 = [0] * len(v0)
	for i in range(len(v0)):
		v2[i] = v0[i] + ((v1[i] - v0[i]) * alpha)
	return v2
class Color3:
	def __init__(self, *args):
		self.r, self.g, self.b = 0, 0, 0
		if len(args) == 1:
			if type(args[0]) == str:
				self.r = int(args[0][0:2], 16) / 255
				self.g = int(args[0][2:4], 16) / 255
				self.b = int(args[0][4:6], 16) / 255
		if len(args) == 3:
			self.r, self.g, self.b = tuple(args)
	@property
	def vector(self):
		return [self.r, self.g, self.b]
	def Lerp(self, to, alpha):
		return Color3(*_LerpV(self.vector, to.vector, alpha))
	def to_pillow_color(self):
		return (int(self.r * 255), int(self.g * 255), int(self.b * 255), 255)

class NumberSequenceKeyframe:
	def __init__(self, time, value, env=0):
		self.time = time
		self.value = value
		self.env = env
class NumberSequence:
	def __init__(self, *args):
		if len(args) == 1:
			self.sequence = args[0][0:]
		if len(args) == 2:
			self.sequence = [
				NumberSequenceKeyframe(0, args[0]),
				NumberSequenceKeyframe(1, args[1])
			]
	def getValue(self, time):
		self.sequence.sort(key=lambda x: x.time)
		v1 = self.sequence[0]
		v2 = v1
		for i in range(len(self.sequence)):
			k1 = self.sequence[i]
			k2 = self.sequence[min(i + 1, len(self.sequence) - 1)]
			if k1.time < time:
				v1 = k1
				v2 = k2
			else:
				break
		a = 0
		diff = v2.time - v1.time
		if diff > 0:
			a = (time - v1.time) / diff
		v1, v2 = v1.value, v2.value
		return v1 + ((v2 - v1) * a)
class ColorSequenceKeyframe:
	def __init__(self, time, value, env=0):
		self.time = time
		self.value = value
		self.env = env
class ColorSequence:
	def __init__(self, *args):
		if len(args) == 1:
			self.sequence = args[0][0:]
		if len(args) == 2:
			self.sequence = [
				ColorSequenceKeyframe(0, args[0]),
				ColorSequenceKeyframe(1, args[1])
			]
	def getValue(self, time):
		self.sequence.sort(key=lambda x: x.time)
		v1 = self.sequence[0]
		v2 = v1
		for i in range(len(self.sequence)):
			k1 = self.sequence[i]
			k2 = self.sequence[min(i + 1, len(self.sequence) - 1)]
			if k1.time < time:
				v1 = k1
				v2 = k2
			else:
				break
		a = 0
		diff = v2.time - v1.time
		if diff > 0:
			a = (time - v1.time) / diff
		v1, v2 = v1.value, v2.value
		return v1.Lerp(v2, a)

class RBXModel:
	@staticmethod
	def parse(raw):
		def _bin(raw):
			RBX_DATA_TYPES = [
				"Unknown", "string", "bool", "int", "float", "double", "UDim", "UDim2", "Ray", "Faces",
				"Axes", "BrickColor", "Color3", "Vector2", "Vector3", "Vector2int16", "CFrame", "Quaternion", "Enum", "Instance",
				"Vector3int16", "NumberSequence", "ColorSequence", "NumberRange", "Rect2D", "PhysicalProperties", "Color3uint8", "int64", "SharedString", "UnknownScriptFormat",
				"Optional", "UniqueId", "Font", "SecurityCapabilities", "Content"
			]
			RBX_FACES = [[1, 0, 0], [0, 1, 0], [0, 0, 1], [-1, 0, 0], [0, -1, 0], [0, 0, -1]]
			b = io.BytesIO(raw)
			b.read(7)
			if b.read(9) != b"\x21\x89\xFF\x0D\x0A\x1A\x0A\x00\x00":
				raise Exception("Header Bytes mismatch, its time to tell the dev about this !!!")
			typeCount, instanceCount = struct.unpack("<II", b.read(4 * 2))
			b.seek(8, 1) # these are usually null bytes, i expect them nothing
			parser = {
				"instances": [None] * instanceCount,
				"types": [None] * typeCount,
				"sharedStrings": [],
				"meta": {},
				"result": []
			}
			while True:
				chunk_type = b.read(4)
				b2 = io.BytesIO(read_lz4(b))
				if chunk_type == b"END\x00":
					break
				if chunk_type == b"META":
					count = struct.unpack("<I", b2.read(4))[0]
					for _ in range(count):
						key = b2.read(struct.unpack("<I", b2.read(4))[0]).decode()
						val = b2.read(struct.unpack("<I", b2.read(4))[0]).decode()
						parser["meta"][key] = val
				if chunk_type == b"SSTR":
					version = struct.unpack("<I", b2.read(4))[0]
					if version == 0:
						count = struct.unpack("<I", b2.read(4))[0]
						for i in range(count):
							b2.read(16)
							val = b2.read(struct.unpack("<I", b2.read(4))[0])
							while len(parser["sharedStrings"]) <= i:
								parser["sharedStrings"].append("")
							parser["sharedStrings"][i] = val
					else:
						raise Warning("We got Shared String V2 before GTA6")
				if chunk_type == b"INST":
					typeID = struct.unpack("<I", b2.read(4))[0]
					className = b2.read(struct.unpack("<I", b2.read(4))[0]).decode()
					if b2.read(1)[0] > 0:
						# we dont read services
						raise Exception("OMG WTF DISCORD SEX ??? OMG DISCORD ??? SEX")
					count = struct.unpack("<I", b2.read(4))[0]
					instances = []
					parser["types"][typeID] = {
						"className": className,
						"instances": instances
					}
					instanceIds = read_RBXInterleavedInt32(b2, count)
					instanceId = 0
					for id in instanceIds:
						instance = Instance(className)
						instances.append(instance)
						instanceId += id
						parser["instances"][instanceId] = instance
				if chunk_type == b"PROP":
					typeID = struct.unpack("<I", b2.read(4))[0]
					typeP = parser["types"][typeID]
					name = b2.read(struct.unpack("<I", b2.read(4))[0]).decode()
					count = len(typeP["instances"])
					def _pprop():
						typeIndex = b2.read(1)[0]
						typeName = "Unknown"
						if typeIndex >= 0 and typeIndex < len(RBX_DATA_TYPES):
							typeName = RBX_DATA_TYPES[typeIndex]
						values: Any = [None] * count
						if typeName == "string":
							for i in range(count):
								v = b2.read(struct.unpack("<I", b2.read(4))[0])
								try:
									values[i] = v.decode()
								except UnicodeDecodeError:
									values[i] = v
						elif typeName == "bool":
							for i in range(count):
								values[i] = b2.read(1)[0] != 0
						elif typeName == "int":
							values = read_RBXInterleavedInt32(b2, count)
						elif typeName == "int64":
							values = read_RBXInterleavedInt64(b2, count)
						elif typeName == "float":
							values = read_RBXInterleavedFloat(b2, count)
						elif typeName == "double":
							for i in range(count):
								values[i] = struct.unpack("<d", b2.read(8))[0]
						elif typeName == "UDim":
							XScale = read_RBXInterleavedFloat(b2, count)
							XOffset = read_RBXInterleavedInt32(b2, count)
							for i in range(count):
								values[i] = {"type": "UDim", "data": [XScale[i], XOffset[i]]}
						elif typeName == "UDim2":
							XScale = read_RBXInterleavedFloat(b2, count)
							XOffset = read_RBXInterleavedInt32(b2, count)
							YScale = read_RBXInterleavedFloat(b2, count)
							YOffset = read_RBXInterleavedInt32(b2, count)
							for i in range(count):
								values[i] = {"type": "UDim2", "data": [XScale[i], XOffset[i], YScale[i], YOffset[i]]}
						elif typeName == "BrickColor":
							intz = read_RBXInterleavedUint32(b2, count)
							for i in range(count):
								values[i] = {"type": "BrickColor", "data": intz[i]}
						elif typeName == "Color3":
							cr = read_RBXInterleavedFloat(b2, count)
							cg = read_RBXInterleavedFloat(b2, count)
							cb = read_RBXInterleavedFloat(b2, count)
							for i in range(count):
								values[i] = Color3(cr[i], cg[i], cb[i])
						elif typeName == "Color3uint8":
							byste = b2.read(count * 3)
							for i in range(count):
								values[i] = Color3(byste[0 + i * 3] / 255, byste[1 + i * 3] / 255, byste[2 + i * 3] / 255)
						elif typeName == "Vector2":
							cr = read_RBXInterleavedFloat(b2, count)
							cg = read_RBXInterleavedFloat(b2, count)
							for i in range(count):
								values[i] = Vector2(cr[i], cg[i])
						elif typeName == "Vector3":
							cr = read_RBXInterleavedFloat(b2, count)
							cg = read_RBXInterleavedFloat(b2, count)
							cb = read_RBXInterleavedFloat(b2, count)
							for i in range(count):
								values[i] = Vector3(cr[i], cg[i], cb[i])
						elif typeName == "CFrame":
							for i in range(count):
								typ = b2.read(1)[0]
								if typ > 0:
									# ig roblox likes to compress rotation of cframes
									rt = RBX_FACES[(typ - 1) // 6]
									up = RBX_FACES[(typ - 1) % 6]
									bk = [
										rt[1] * up[2] - up[1] * rt[2],
										rt[2] * up[0] - up[2] * rt[0],
										rt[0] * up[1] - up[0] * rt[1]
									]
									values[i] = CFrame(
										0, 0, 0,
										rt[0], up[0], bk[0],
										rt[1], up[1], bk[1],
										rt[2], up[2], bk[2]
									)
								else:
									s = []
									for _ in range(9):
										s.append(struct.unpack("<f", b2.read(4))[0])
									values[i] = CFrame(0, 0, 0, *s)
							cr = read_RBXInterleavedFloat(b2, count)
							cg = read_RBXInterleavedFloat(b2, count)
							cb = read_RBXInterleavedFloat(b2, count)
							for i in range(count):
								values[i].x = cr[i]
								values[i].y = cg[i]
								values[i].z = cb[i]
						elif typeName == "Enum":
							intz = read_RBXInterleavedUint32(b2, count)
							for i in range(count):
								values[i] = {"type": "Enum", "data": intz[i]}
						elif typeName == "Instance":
							intz = read_RBXInterleavedInt32(b2, count)
							instanceId = 0
							for i in range(count):
								instanceId += intz[i]
								values[i] = parser["instances"][instanceId]
						elif typeName == "NumberSequence":
							for i in range(count):
								le = struct.unpack("<I", b2.read(4))[0]
								s = []
								for _ in range(le):
									s.append(NumberSequenceKeyframe(
										struct.unpack("<f", b2.read(4))[0],
										struct.unpack("<f", b2.read(4))[0],
										struct.unpack("<f", b2.read(4))[0]
									))
								values[i] = NumberSequence(s)
						elif typeName == "ColorSequence":
							for i in range(count):
								le = struct.unpack("<I", b2.read(4))[0]
								s = []
								for _ in range(le):
									s.append(ColorSequenceKeyframe(
										struct.unpack("<f", b2.read(4))[0],
										Color3(
											struct.unpack("<f", b2.read(4))[0],
											struct.unpack("<f", b2.read(4))[0],
											struct.unpack("<f", b2.read(4))[0]
										),
										struct.unpack("<f", b2.read(4))[0]
									))
								values[i] = ColorSequence(s)
						elif typeName == "NumberRange":
							for i in range(count):
								values[i] = {"type": "NumberRange", "data": [
									struct.unpack("<f", b2.read(4))[0], struct.unpack("<f", b2.read(4))[0]
								]}
						elif typeName == "PhysicalProperties":
							for i in range(count):
								pp = []
								if b2.read(1)[0] != 0:
									pp = [
										struct.unpack("<f", b2.read(4))[0],
										struct.unpack("<f", b2.read(4))[0],
										struct.unpack("<f", b2.read(4))[0],
										struct.unpack("<f", b2.read(4))[0],
										struct.unpack("<f", b2.read(4))[0]
									]
								values[i] = {"type": "PhysicalProperties", "data": pp}
						elif typeName == "SharedString":
							typeName = "string"
							intz = read_RBXInterleavedUint32(b2, count)
							for i in range(count):
								values[i] = parser["sharedStrings"][intz[i]]
						elif typeName == "SecurityCapabilities":
							read_RBXInterleavedInt64(b2, count)
							typeName = None
						else:
							raise Exception(typeName, hex(typeIndex), typeP["className"], name)
							#print(typeName, hex(typeIndex), typeP["className"], name)
							for i in range(count):
								values[i] = "<" + hex(typeIndex) + ">"
							typeName = None
						return values, typeName
					values, valueType = _pprop()
					if valueType is not None:
						for i in range(count):
							inst = typeP["instances"][i]
							val = values[i]
							setattr(inst, name, val)
				if chunk_type == b"PRNT":
					b2.read(1)
					count = struct.unpack("<I", b2.read(4))[0]
					childIds = read_RBXInterleavedInt32(b2, count)
					parentIds = read_RBXInterleavedInt32(b2, count)
					childId = 0
					parentId = 0
					for i in range(count):
						childId += childIds[i]
						parentId += parentIds[i]
						child = parser["instances"][childId]
						if parentId >= 0:
							parent = parser["instances"][parentId]
							child.Parent = parent
						else:
							parser["result"].append(child)
			return parser["result"]
		def _xml(raw):
			def unescape_xml(value):
				if isinstance(value, bytes):
					value = value.decode()
				if value.startswith("<![CDATA["):
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
					lookup = {ord(c): i for i, c in enumerate(chars)}
					def decode_base64(base64_str, start_index, end_index):
						base64_str = base64_str[start_index:end_index]
						padding = base64_str.count("=")
						buffer_length = len(base64_str) * 0.75 - padding
						bytes_array = bytearray(int(buffer_length))
						p = 0
						for i in range(0, len(base64_str), 4):
							encoded1 = lookup.get(ord(base64_str[i]), 0)
							encoded2 = lookup.get(ord(base64_str[i + 1]), 0)
							encoded3 = lookup.get(ord(base64_str[i + 2]), 0)
							encoded4 = lookup.get(ord(base64_str[i + 3]), 0)
							bytes_array[p] = (encoded1 << 2) | (encoded2 >> 4)
							p += 1
							if i + 2 < len(base64_str):
								bytes_array[p] = ((encoded2 & 15) << 4) | (encoded3 >> 2)
								p += 1
							if i + 3 < len(base64_str):
								bytes_array[p] = ((encoded3 & 3) << 6) | encoded4
								p += 1
						return bytes_array[:p]
					def buffer_to_string(byte_buffer):
						return byte_buffer.decode("utf-8", errors="replace")
					return buffer_to_string(decode_base64(value, 9, -3))
				def replace_entity(match):
					prefix, inner = match.groups()
					byte = int(inner[1:], 16) if inner.startswith("x") else int(inner)
					return f"{prefix}{chr(byte)}"
				value = re.sub(
					r"(?<!&)((?:&{2})*)&#(\d{1,4}|x[0-9a-fA-F]{1,4});",
					replace_entity,
					value
				)
				return value.replace("&&", "&")
			xml = ET.fromstring(unescape_xml(raw))
			parser = {
				"referents": {},
				"propertieses": [],
				"sharedStrings": {},
				"meta": {},
				"result": []
			}
			def _item(parser, child):
				inst = Instance(child.get("class", "Instance"))
				referent = child.get("referent")
				if referent is not None:
					parser["referents"][referent] = inst
				for ch in list(child):
					if ch.tag == "Item":
						chinst = _item(parser, ch)
						chinst.Parent = inst
					if ch.tag == "Properties":
						parser["propertieses"].append({
							"target": inst,
							"node": ch
						})
				return inst
			def _prop(node):
				x = {}
				for y in list(node):
					x[y.tag] = y.text
				return x
			for child in list(xml):
				if child.tag == "Item":
					parser["result"].append(_item(parser, child))
				if child.tag == "SharedStrings":
					for ss in list(child):
						if ss.tag != "SharedString":
							continue
						md5 = ss.get("md5", "hi lmao")
						value = base64.b64decode(ss.text.strip().encode()).decode()
						parser["sharedStrings"][md5] = value
				if child.tag == "Meta":
					pass  # skipping cuz whitespace demons
			for propdata in parser["propertieses"]:
				inst = propdata["target"]
				props = propdata["node"]
				for prop in list(props):
					name = prop.get("name", "Unknown")
					minis = _prop(prop)
					typeName = prop.tag
					value = None
					if typeName in ["string", "ProtectedString", "BinaryString"]:
						if prop.text:
							value = unescape_xml(prop.text.strip())
						else:
							value = ""
					elif typeName == "Content":
						value = unescape_xml(minis["url"])
					elif typeName in ["double", "float"]:
						value = parseFloat(prop.text.strip()) or 0
					elif typeName in ["int", "int64"]:
						value = parseInt(prop.text.strip()) or 0
					elif typeName == "bool":
						value = prop.text.strip() == "true"
					elif typeName == "Color3":
						value = Color3(
							parseFloat(minis["R"]) or 0,
							parseFloat(minis["G"]) or 0,
							parseFloat(minis["B"]) or 0
						)
					elif typeName == "Color3uint8":
						v = parseInt(prop.text.strip()) or 0
						value = Color3(
							((v >> 16) & 0xFF) / 255,
							((v >> 8) & 0xFF) / 255,
							(v & 0xFF) / 255
						)
					elif typeName == "CoordinateFrame":
						value = CFrame(
							parseFloat(minis["X"]),
							parseFloat(minis["Y"]),
							parseFloat(minis["Z"]),
							parseFloat(minis["R00"]),
							parseFloat(minis["R01"]),
							parseFloat(minis["R02"]),
							parseFloat(minis["R10"]),
							parseFloat(minis["R11"]),
							parseFloat(minis["R12"]),
							parseFloat(minis["R20"]),
							parseFloat(minis["R21"]),
							parseFloat(minis["R22"])
						)
					elif typeName == "OptionalCoordinateFrame":
						minos = _prop(list(prop)[0])
						value = CFrame(
							parseFloat(minos["X"]),
							parseFloat(minos["Y"]),
							parseFloat(minos["Z"]),
							parseFloat(minos["R00"]),
							parseFloat(minos["R01"]),
							parseFloat(minos["R02"]),
							parseFloat(minos["R10"]),
							parseFloat(minos["R11"]),
							parseFloat(minos["R12"]),
							parseFloat(minos["R20"]),
							parseFloat(minos["R21"]),
							parseFloat(minos["R22"])
						)
					elif typeName == "Vector3":
						value = Vector3(
							parseFloat(minis["X"]) or 0,
							parseFloat(minis["Y"]) or 0,
							parseFloat(minis["Z"]) or 0
						)
					elif typeName == "Vector2":
						value = Vector2(
							parseFloat(minis["X"]) or 0,
							parseFloat(minis["Y"]) or 0
						)
					elif typeName == "Vector3int16":
						value = Vector3(
							parseFloat(minis["X"]) or 0,
							parseFloat(minis["Y"]) or 0,
							parseFloat(minis["Z"]) or 0
						)
					elif typeName == "Vector2int16":
						value = Vector2(
							parseFloat(minis["X"]) or 0,
							parseFloat(minis["Y"]) or 0
						)
					elif typeName == "UDim":
						value = {"type": "UDim", "data": [
							parseFloat(minis["S"]) or 0,
							parseFloat(minis["O"]) or 0
						]}
					elif typeName == "UDim2":
						value = {"type": "UDim2", "data": [
							parseFloat(minis["XS"]) or 0,
							parseFloat(minis["XO"]) or 0,
							parseFloat(minis["YS"]) or 0,
							parseFloat(minis["YO"]) or 0
						]}
					elif typeName == "token":
						value = {"type": "Enum", "data": parseInt(prop.text.strip()) or 0}
					elif typeName == "SharedString":
						value = parser["sharedStrings"].get(prop.text.strip(), "")
					elif typeName == "Ref":
						value = parser["referents"].get(prop.text.strip())
					if value is not None:
						setattr(inst, name, value)
			return parser["result"]
		assert raw[:7] == b"<roblox", "Invalid RBXM file"
		if raw[7] == 0x21:
			return _bin(raw)
		else:
			return _xml(raw)

def makeverify(raw):
	print("Creating verify script...")
	f = open("verify.lua", "rt")
	script = f.read()
	f.close()
	hi = ""
	hi2 = raw.hex()
	i = 0
	while i < len(hi2):
		hi += "\\x" + hi2[i:i + 2]
		i += 2
	script = script.replace("[DATAINSERTION]", hi)
	f = open("verify2.lua", "wt")
	f.write(script)
	f.close()
def convert(inst):
	print("Converting instance...")
	e_style = ["Linear", "Constant", "Elastic", "Cubic", "Bounce", "CubicV2"]
	e_direc = ["In", "Out", "InOut"]
	b = io.BytesIO()
	def putshort(x):
		b.write(struct.pack("<H", x))
	def putstring(s):
		s = s.encode()
		putshort(len(s))
		b.write(s)
	def putsizet(x):
		b.write(struct.pack("<I", x))
	def putfloat(x):
		b.write(struct.pack("<f", x))
	putstring(inst.Name)
	kfs = []
	for kf in inst.GetChildren():
		if kf.ClassName == "Keyframe":
			kfs.append(kf)
	putsizet(len(kfs))
	totaltime = 0
	for kf in kfs:
		t = kf.Time or 0
		totaltime = max(totaltime, t)
		putfloat(t)
		poses = []
		for pose in kf.GetDescendants():
			if pose.ClassName == "Pose":
				poses.append(pose)
		putsizet(len(poses))
		for pose in poses:
			putstring(pose.Name)
			putfloat(pose.Weight or 1)
			putstring(e_style[(pose.EasingStyle or {}).get("data", 0)])
			putstring(e_direc[(pose.EasingDirection or {}).get("data", 0)])
			cf = pose.CFrame or CFrame()
			for comp in cf.get_components():
				putfloat(comp)
	print("Information:")
	print("  Name: " + inst.Name)
	print("  Keyframes: " + str(len(kfs)))
	print("  End Time: " + str(totaltime))
	b.seek(0, 0)
	path = inst.Name + ".anim"
	print("Saving to " + path + "...")
	f = open(path, "wb")
	raw = b.read()
	f.write(raw)
	f.close()
	print("Done.")
	#makeverify(raw)
def parsenconvert(path):
	print("Reading file...")
	f = open(path, "rb")
	raw = f.read()
	f.close()
	print("Parsing...")
	insts = RBXModel.parse(raw)
	assert len(insts) > 0, "Empty RBXM"
	while True:
		assert len(insts) > 0, "DEAD END"
		if len(insts) == 1 and insts[0].ClassName == "KeyframeSequence":
			return convert(insts[0])
		print("Pick the KeyframeSequence (or traverse the dungeon)")
		for i in range(len(insts)):
			print("  " + str(i + 1) + " - " + insts[i].Name + " (" + insts[i].ClassName + ")")
		print("  " + str(len(insts)) + " - Convert every KeyframeSequence here)")
		pick = input("YOUR selection: ")
		try:
			pick = int(pick) - 1
			if pick >= 0 and pick < len(insts):
				if insts[pick].ClassName == "KeyframeSequence":
					return convert(insts[pick])
				insts = insts[pick].GetChildren()
			elif pick == len(insts):
				for inst in insts:
					if inst.ClassName == "KeyframeSequence":
						convert(inst)
				return
		except ValueError:
			pass

import sys
def main(args):
	print("RBXM To STEVE's KeyframeSequence file format")
	print("Hello! I convert RBXM files to STEVE's KeyframeSequence file format.")
	print("I also know about RBXMX, and I looooove C structs!")
	if len(args) >= 2:
		return parsenconvert(args[1])
	print("Usage: rbxm2anim.py [path to rbxm]")
	return parsenconvert(input("  or enter path here: "))

if __name__ == "__main__":
	main(sys.argv)