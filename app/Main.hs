module Main (main) where

import qualified Data.MonadicByteString as MS
import qualified Data.ByteString as BS
import qualified Protocol.Packet as P 
import Control.Monad.State
import Net.Stub (sendDNSStubRequest)
import Protocol.Packet (parseDNSPacket)



testParsePacket:: BS.ByteString -> IO()
testParsePacket bytes = do
                            let packet = evalState (P.parseDNSPacket bytes) 0
                            print packet
                            let ser_bytes = P.serialIzeDNSPacket packet
                            let parse_again = evalState (P.parseDNSPacket ser_bytes) 0
                            print parse_again


main :: IO ()
main = do
    let request =  BS.pack [0x41, 0xC5, 0x01, 0x20, 0x00, 0x01, 0x00, 0x00, 
                             0x00, 0x00, 0x00, 0x00, 0x06, 0x67, 0x6F, 0x6F, 
                             0x67, 0x6C, 0x65, 0x03, 0x63, 0x6F, 0x6D, 0x00, 
                             0x00, 0x01, 0x00, 0x01]
    -- let packet =  BS.pack 
    --         [ 0x41, 0xC5, 0x81, 0x80, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
    --         , 0x06, 0x67, 0x6F, 0x6F, 0x67, 0x6C, 0x65, 0x03, 0x63, 0x6F, 0x6D, 0x00
    --         , 0x00, 0x01, 0x00, 0x01, 0xC0, 0x0C, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00
    --         , 0x00, 0x2F, 0x00, 0x04, 0xAC, 0xD9, 0xA6, 0x0E 
    --         ]
    let parsed = evalState (parseDNSPacket request) 0
    print parsed
    sendDNSStubRequest parsed
    
