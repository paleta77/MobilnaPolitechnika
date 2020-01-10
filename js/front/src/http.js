
let base = "http://localhost:8080/";

export async function post(url, data = {}, headers = {}) {
    const response = await fetch(base + url, {
        method: 'POST',
        cache: 'no-cache',
        headers: { ...{ 'Content-Type': 'application/json' }, ...headers },
        referrer: 'no-referrer',
        body: JSON.stringify(data)
    });
    return await response.json();
}

export async function get(url, headers = {}) {
    const response = await fetch(base + url, {
        cache: 'no-cache',
        headers: { ...{ 'Content-Type': 'application/json' }, ...headers },
        referrer: 'no-referrer'
    });
    return await response.json();
}

export async function del(url, data = {}, headers = {}) {
    const response = await fetch(base + url, {
        method: 'DELETE',
        cache: 'no-cache',
        headers: { ...{ 'Content-Type': 'application/json' }, ...headers },
        referrer: 'no-referrer',
        body: JSON.stringify(data)
    });
    return await response.json();
}

export async function put(url, data = {}, headers = {}) {
    const response = await fetch(base + url, {
        method: 'PUT',
        cache: 'no-cache',
        headers: { ...{ 'Content-Type': 'application/json' }, ...headers },
        referrer: 'no-referrer',
        body: JSON.stringify(data)
    });
    return await response.json();
}