import os
import pathlib

import pytest

from testsuite.daemons import service_client

pytest_plugins = [
    'testsuite.pytest_plugin',
]

SERVICE_BASEURL = 'http://localhost:8080/'

bla lba

@pytest.fixture
async def server_client(
        service_daemon,
        service_client_options,
        ensure_daemon_started,
        mockserver,
):
    await ensure_daemon_started(service_daemon)
    yield service_client.Client(SERVICE_BASEURL, **service_client_options)


# remove scope=session to restart service on each test
@pytest.fixture(scope='session')
async def service_daemon(
        register_daemon_scope, service_spawner, mockserver_info,
):
    service_path = pathlib.Path(__file__).parent
    async with register_daemon_scope(
            name='service-template',
            spawn=service_spawner(
                [
                    str(service_path.joinpath('build_debug/service-template')),
                    '--storage-service-url',
                    mockserver_info.base_url + 'storage/',
                ],
                check_url=SERVICE_BASEURL + 'ping',
            ),
    ) as scope:
        yield scope
