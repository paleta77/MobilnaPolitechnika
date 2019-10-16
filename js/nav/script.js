let last = null;
let mesh = { nodes: [], edges: [] }
let a = document.getElementById("floor");
let edges = document.getElementById("edges");
let buttons = document.getElementById("buttons");
let svgDoc;
let foreground;
let background;
let floors;
let startNode;
let path = null;
let _3D = true;

const lineStyle = "stroke:#0000FF;stroke-width:0.6;stroke-linecap:square;stroke-linejoin:miter;stroke-miterlimit:4;";
const pathStyle = "stroke:#00FF00;stroke-width:0.6;stroke-linecap:square;stroke-linejoin:miter;stroke-miterlimit:4;";
console.log("hle?");
a.addEventListener("load", function () {

	svgDoc = a.contentDocument;
	buttons.style.display = 'none';

	foreground = svgDoc.getElementById("layer4");
	background = svgDoc.getElementById("layer7");
	floors = []
	let floors_el = svgDoc.getElementById("layer6");

	for (let child = floors_el.firstChild; child !== null; child = child.nextSibling) {
		if (child.localName == "g") {
			floors.push(child);
			if (_3D) {
				child.style.display = "block";
				child.style.transform = " perspective(10000px) rotateX(68.4deg) translateZ(" + (-70 + 30 * (floors.length - 1)) + "px)";
			}
			else {
				child.style.display = "none";
			}

		}
	}
	let slider = document.getElementById("floorSlider");
	slider.max = floors.length;
	changeFloor();

	let delta = svgDoc.getElementsByTagName("circle");
	for (let i = 0; i < delta.length; i++) {
		delta[i].style.display = 'none';
		let title = delta[i].getElementsByTagName("title");
		let name = null;
		if (title.length > 0) {
			name = title[0].innerHTML;
		}

		let floor = parseInt(delta[i].parentNode.parentNode.getAttribute("inkscape:label").replace("Floor", ""));

		let node = { element: delta[i], id: name, floor: floor, x: delta[i].cx.baseVal.value, y: delta[i].cy.baseVal.value, neighbors: [] };
		delta[i].myNode = node;
		mesh.nodes.push(node);

		if (name != null && name != "START") {
			let btn = document.createElement("button");
			btn.innerHTML = name;
			btn.myNode = node;
			btn.onclick = function (e) { dijkstra(startNode, e.target.myNode) };
			buttons.appendChild(btn);
		}

		if (name == "START")
			startNode = node;

		// TODO: remove y offset of 177
		/*delta[i].addEventListener("mousedown", function (e) {
			//alert("ok");
			if (last == null)
				last = e.target;
			else {
				console.log(last.id + " " + e.target.id);
				let el = getChildWithAttribute(floors[slider.value - 1], "inkscape:label", "mesh");
				el.appendChild(getNode('line', { x1: last.cx.baseVal.value, y1: last.cy.baseVal.value - 177, x2: e.target.cx.baseVal.value, y2: e.target.cy.baseVal.value - 177, style: lineStyle }));
				let len = Math.sqrt(Math.pow(last.cx.baseVal.value - e.target.cx.baseVal.value, 2) + Math.pow(last.cy.baseVal.value - e.target.cy.baseVal.value, 2));
				edges.value += last.id + " " + e.target.id + " " + len + " " + (slider.value - 1) + "\n";

				last = null;
			}
		}, false);*/
	}
}, false);


function getChildWithAttribute(parent, el, name) {
	for (let child = parent.firstChild; child !== null; child = child.nextSibling) {
		if (child.nodeName != "#text") {
			if (child.getAttribute(el) == name) {
				return child;
			}
		}
	}
	return null;
}

function getNode(n, v) {
	n = document.createElementNS("http://www.w3.org/2000/svg", n);
	for (let p in v)
		n.setAttributeNS(null, p, v[p]);
	return n
}

function loadMesh() {
	buttons.style.display = 'block';
	let lines = edges.value.split(/\n/);

	for (let el in lines) {
		let parts = lines[el].split(' ')
		if (parts.length >= 3) {
			let a = svgDoc.getElementById(parts[0]);
			let b = svgDoc.getElementById(parts[1]);
			let len = parseFloat(parts[2])
			let layer = parseInt(parts[3])
			let el = getChildWithAttribute(floors[layer], "inkscape:label", "mesh");
			el.appendChild(getNode('line', { x1: a.cx.baseVal.value, y1: a.cy.baseVal.value, x2: b.cx.baseVal.value, y2: b.cy.baseVal.value, style: lineStyle }));

			a.myNode.neighbors.push({ b: b.myNode, len: len });
			b.myNode.neighbors.push({ b: a.myNode, len: len });
			mesh.edges.push({ a: a.myNode, b: b.myNode, len: len });
		}
	}
}

function smallest(set) {
	let minimum = 0;

	for (let i = 1; i < set.length; i++) {
		if (set[i].dist < set[minimum].dist)
			minimum = i;
	}
	return minimum;
}

function dijkstra(start, end) {
	q = []

	for (let i = 0; i < mesh.nodes.length; i++) {
		let node = mesh.nodes[i];
		node.dist = Infinity;
		node.prev = null;
		q.push(node);
	}

	start.dist = 0;

	while (q.length > 0) {
		u_idx = smallest(q);
		u = q[u_idx];
		q.splice(u_idx, 1);

		for (let i = 0; i < u.neighbors.length; i++) {
			let v = u.neighbors[i];
			let alt = u.dist + v.len;
			if (alt < v.b.dist) {
				v.b.dist = alt;
				v.b.prev = u;
			}
		}
	}

	s = [];
	u = end;
	if (u.prev != null || u === start) {
		while (u != null) {
			s.unshift(u)
			u = u.prev
		}
	}

	path = s;
	drawPath();
}

function drawPath(max = -1) {
	for (let i = 0; i < floors.length; i++) {
		let el = getChildWithAttribute(floors[i], "inkscape:label", "mesh");
		while (el.firstChild) {
			el.firstChild.remove();
		}
	}

	if (max == -1 || max > path.length - 1)
		max = path.length - 1;
	else
		max = max;

	let last_floor = 0;

	for (let i = 0; i < max; i++) {
		let a = path[i];
		let b = path[i + 1];
		/*if (a.floor == b.floor) {
			let el = getChildWithAttribute(floors[a.floor], "inkscape:label", "mesh");
			el.appendChild(getNode('line', { x1: a.x, y1: a.y - 177, x2: b.x, y2: b.y - 177, style: pathStyle }));
			
		}
		else {*/
		let el = getChildWithAttribute(floors[b.floor], "inkscape:label", "mesh");
		el.appendChild(getNode('line', { x1: a.x, y1: a.y - 177, x2: b.x, y2: b.y - 177, style: pathStyle }));
		//}
		last_floor = b.floor;
	}
	let slider = document.getElementById("floorSlider");
	slider.value = last_floor + 1;
	changeFloor();
}

let framenum = 0;

function animation() {
	drawPath(framenum);
	framenum++;
	if (framenum < path.length)
		setTimeout(animation, 800);
}

function play() {
	framenum = 0;
	animation();
}

function changeFloor() {
	let slider = document.getElementById("floorSlider");
	slider.value;
	for (let i = 0; i < floors.length; i++) {
		if (!_3D) {
			if (i == slider.value - 1)
				floors[i].style.display = 'block';
			else
				floors[i].style.display = 'none';
		}
		else
		{
			// TODO: make floors transparent in 3D
		}
	}
}
