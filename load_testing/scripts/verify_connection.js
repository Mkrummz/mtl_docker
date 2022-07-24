import http from 'k6/http'
import { sleep } from 'k6'

// This BASE_URL won't work if you're using Docker.
// You'll need to know the IP address of the host.
// Then replace localhost with the IP address.
const BASE_URL = 'http://host.docker.internal:3389/cart?name=Maggie'

export default function() {
    const res = http.get(BASE_URL)
    console.log('response body', res.body)
    sleep(1)
}